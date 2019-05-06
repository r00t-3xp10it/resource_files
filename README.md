## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**<br />
![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

### DISCLAMER
The resource scripts this repository contains serves as proof of concept (**POC**) of this [article](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files) published on resource files scripting. This repository is designed to demonstrate what resource files [ERB](https://www.offensive-security.com/metasploit-unleashed/custom-scripting/) can accomplish when automating tasks in msfconsole, and they are written to take advantage of multi-hosts-exploitation-scan tasks (manage large databases of hosts) from scanning the local lan for alive hosts, scan attackers input rhosts or scan wan networks in search of rhosts to exploit/brute-force. 'They are **not** written with the objective of exploiting remote targets, but to serve as inspiration for msf developing'. This repository shows above all how [nmap](https://nmap.org/) and [metasploit](https://www.metasploit.com/) frameworks are amazing tools.

<br />

### REMARK
The **brute force** resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new [workspace](https://www.offensive-security.com/metasploit-unleashed/using-databases/#Workspaces) named **'redteam'** and stores all the data inside that workspace while working, then the resource script deletes the **'redteam'** workspace in the end of execution.<br />**(This action allow us to mantain the attacker *default workspace database intact).**

<br />

**WARNING:**<br />
This resource scripts can **NOT** be run inside meterpreter prompt because **ERB** code its not accepted there.<br />
In **'post_exploitation.rc'** case, simple **background** the current session and then load the resource script.
![pic](https://i.imgur.com/BVWzYlJ.png)

<br />

### INDEX

- [1] [Using 'setg' (msf) to config rc scripts](https://github.com/r00t-3xp10it/resource_files#using-setg-global-variables-to-config-this-kind-of-rc-scripts)
- [2] [Brute_force.rc - Demonstration exercise (WAN)](https://github.com/r00t-3xp10it/resource_files#brute_forcerc-demonstration-exercise)
- [3] [Manage_db.rc - Demonstration exercise (WAN)](https://github.com/r00t-3xp10it/resource_files#manage_dbrc-demonstration-exercise)
- [4] [Article about resource files scripting (github)](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)
- [5] WIKI-PAGES
  - [offensive resource scripts | Dependencies](https://github.com/r00t-3xp10it/resource_files/wiki/Offensive-Resource_Files-%7C-Dependencies)
  - [offensive resource script | geo_location.rc](https://github.com/r00t-3xp10it/resource_files/wiki/Offensive-Resource_Files--%7C-Geo_Location)
  - [offensive resource script | post_exploitation.rc](https://github.com/r00t-3xp10it/resource_files/wiki/post_exploitation.rc-%7C-offensive-resource-script)

---

<br /><br /><br />

### USING 'SETG' GLOBAL VARIABLES TO CONFIG THIS KIND OF RC SCRIPTS

![pic](http://i67.tinypic.com/2iu59g7.png)
Many of the this brute force resource scripts are written to accept **user inputs** (msfconsole setg global variable).<br />**This means that i have written this resource scripts to work in 3 diferent ways:**

Execute resource script againts local lan

      msfconsole -r /root/mysql_brute.rc

Instruct the resource script to scan hosts input by the attacker

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;resource /root/mysql_brute.rc'

Instruct the resource script to search in WAN for hosts with the service port open (mysql port/service)

      msfconsole -q -x 'setg RANDOM_HOSTS true;resource /root/mysql_brute.rc'

<br /><br />

**Adicionally to the described settings, we can also combine diferent configurations at runtime execution.**<br />
Instruct the resource script to search in WAN for rhosts with service port open and limmit the search to 300 hosts

      msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 300;resource /root/mysql_brute.rc'

Instruct the resource script to use attackers dicionary file (absoluct path required)

      msfconsole -q -x 'setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

Instruct the resource script to scan rhosts input by attacker, and use the attacker dicionary file 

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;setg USERPASS_FILE dicionary.txt;resource mysql_brute.rc'

#### [!] [Jump to readme file index](https://github.com/r00t-3xp10it/resource_files#index)

---

<br /><br /><br />

### BRUTE_FORCE.RC DEMONSTRATION EXERCISE
![pic](http://i64.tinypic.com/210g9bp.gif)

**Step-By-Step how to run 'brute_force.rc' script**<br />

1º download the resource script to your **/root** folder<br />

      wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/brute_force.rc

2º download wordlist (dicionary file)

      wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/multi_services_wordlist.txt

3º start postgresql service (**local machine**)<br />

      service postgresql start

4º run brute_force.rc resource script to search hosts in WAN (**limmit the search to 200 hosts**)<br />

      msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 200;setg USERPASS_FILE multi_services_wordlist.txt;resource brute_force.rc'

<br /><br />

#### REMARK
"This brute force resource scripts deletes the **redteam** workspace at execution exit".<br />
How to instruct this scripts to export **redteam** workspace database to a local file at the end of execution? **(database.xml)**<br />

      msfconsole -q -x 'setg SAVE_DB true;setg RANDOM_HOSTS true;setg LIMMIT 200;resource /root/brute_force.rc'

This database.xml file can now be **'imported'** to your *default workspace with the follow command:

      msfconsole -q -x 'db_import /root/database.xml'

#### REMARK
importing this database.xml files **appends** data to your *default workspace database making it larger.<br />
It does **'not'** delete any entries that you have before on your *default workspace database (it only appends data).

#### [!] [Jump to readme file index](https://github.com/r00t-3xp10it/resource_files#index)

---

<br />

### CREDITS

**@fyodor** [nmap] | **@hdmoore** [metasploit] | **@enigma0x3** | **@darkoperator**<br />
About 10 years ago (2009) I heard the creator of metasploit say: **'Automation is the name of the pentest game'**.<br />
Then in 2011 i have read this article [rapid7-@hdmoore](https://blog.rapid7.com/2011/12/08/six-ways-to-automate-metasploit/) and everything have changed for me since that day.<br />
**'Thank you for all the inspiration l33t @hdmoore'** ..

### Suspicious Shell Activity RedTeam @2019

