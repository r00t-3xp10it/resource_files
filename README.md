## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**<br />
![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

### DISCLAMER
The resource scripts that this repository contains serves as proof of concept (**POC**) of this [article](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files) published on resource files scripting. This repository is designed to demonstrate what resource files [ERB](https://www.offensive-security.com/metasploit-unleashed/custom-scripting/) can accomplish when automating tasks in msfconsole, and they are written to take advantage of multi-hosts-exploitation-scan tasks (manage large databases of hosts) from scanning the local lan for alive hosts, scan attackers input rhosts or scan wan networks in search of rhosts to exploit/brute-force. 'They are **not** written with the objective of exploiting remote targets, but to serve as inspiration for msf developing'.

<br />

### REMARK
This brute force resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new [workspace](https://www.offensive-security.com/metasploit-unleashed/using-databases/#Workspaces) named **'redteam'** and stores all the data inside that workspace while working, then the resource script deletes the **'redteam'** workspace in the end of execution. (This action allow us to mantain the attacker *default workspace database intact). The only script that does not create **redteam** workspace its **manage_db.rc**.<br />
Why ? to allow users to manage all workspaces (databases) if needed and not only the redteam workspace.

<br />

### INDEX

- [1] [Using 'setg' (msf) to config rc scripts](https://github.com/r00t-3xp10it/resource_files#using-setg-global-variables-to-config-this-kind-of-rc-scripts)
- [2] [Step-by-step - How to run brute_force.rc script](https://github.com/r00t-3xp10it/resource_files#step-by-step-how-to-run-brute_forcerc-script)
- [3] [Manage_db.rc - Demonstration exercise (WAN)](https://github.com/r00t-3xp10it/resource_files#manage_dbrc-demonstration-exercise)
- [4] [Article about resource files scripting (github)](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

---

<br /><br /><br />

### USING 'SETG' GLOBAL VARIABLES TO CONFIG THIS KIND OF RC SCRIPTS

![pic](http://i67.tinypic.com/2iu59g7.png)
Many of the this brute force resource scripts are written to accept **user inputs** (msfconsole setg global variable).<br />This means that i have written this resource scripts to work in 3 diferent ways:

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

### Step-By-Step how to run 'brute_force.rc' script

1º download the resource script to your **/root** folder<br />

      sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/brute_force.rc

2º start postgresql service (**local machine**)<br />

      sudo service postgresql start

3º run brute_force.rc resource script to search hosts in WAN (**limmit the search to 200 hosts**)<br />

      sudo msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 200;resource /root/brute_force.rc'

#### REMARK
This brute force resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new workspace named **'redteam'** and stores all the data inside that workspace while working, then the resource script deletes the **'redteam'** workspace in the end of execution. (This action allow us to mantain the attacker *default workspace database intact).

How to instruct this scripts to export **redteam** workspace database to a local file at the end of execution? **(database.xml)**<br />

      msfconsole -q -x 'setg SAVE_DB true;setg RANDOM_HOSTS true;setg LIMMIT 200;resource /root/brute_force.rc'

This database.xml file can now be **'imported'** to your *default workspace with the follow command:

      sudo msfconsole -q -x 'db_import /root/database.xml'

#### REMARK
importing this database.xml files **appends** data to your *default workspace database making it larger.<br />
It does **'not'** delete any entries that you have before on your *default workspace database (it only appends data).

#### [!] [Jump to readme file index](https://github.com/r00t-3xp10it/resource_files#index)

---

<br /><br /><br />

### MANAGE_DB.RC DEMONSTRATION EXERCISE
Adicionally to all brute force rc scripts and core commands rc scripts, i have written one resource file to manage database common tasks like: Display database stored data, record msfconsole activity (Logfile.log), add hosts to database, import/export files.xml import list of hosts contained on a text file (one-per-line-entries), auto_brute force db hosts by service name, auto search compatible auxiliarys modules based on db hosts service names, export database data to one CSV file, the RUN_RC option that allow us to execute another script.rc before manage_db.rc ends execution and clean all database data at script exit.
![pic](http://i65.tinypic.com/opwwig.gif)

**Step-By-Step how to download/run 'manage_db.rc' script**<br />
1º download demonstration hosts list (txt)

      wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/remote_hosts.txt

2º download manage_db.rc script to your **/root** folder<br />

      sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/manage_db.rc

3º download http_CVE.rc script to your **/root** folder<br />

      wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/http_CVE.rc

4º download freevulnsearch.nse and port it to nmap

      wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/freevulnsearch.nse
      sudo cp freevulnsearch.nse /usr/share/nmap/scripts/freevulnsearch.nse
      sudo nmap --script-updatedb

5º start postgresql service (**local machine**)<br />

      sudo service postgresql start

6º execute manage_db.rc and http_CVE.rc together (setg run_rc http_CVE.rc)

      msfconsole -q -x 'setg txt_import remote_hosts.txt;setg db_scan true;setg run_rc http_CVE.rc;setg save_db true;resource manage_db.rc'

7º import the scan made by:http_CVE.rc to *default workspace database

      setg xml_import database_<random-letters>.xml
      resource manage_db.rc

8º viewing database notes

      notes
      notes -S '(WWW_AUTHENTICATE|nmap.nse.http-headers.tcp.80)'
      notes -S '(nmap.nse.freevulnsearch.tcp.22|nmap.nse.freevulnsearch.tcp.53)'

9º clean *default workspace database

      setg clean true
      resource manage_db.rc
      exit -y
      service postgesql stop

#### Final note:
Remmenber that we can **'abort'** scans simple by pressing the **[CTRL+C]** in command prompt, that hotkey will abort msf auxiliary execution and jump to resource script next funtion (another auxiliary module scan or another funtion inside rc script).

#### [!] [Jump to readme file index](https://github.com/r00t-3xp10it/resource_files#index)

---

<br /><br /><br />

### CREDITS

About 10 years ago (2009) I heard the creator of metasploit say: **'Automation is the name of the pentest game'**.<br />
Then in 2011 i have read this article [rapid7-@hdmoore](https://blog.rapid7.com/2011/12/08/six-ways-to-automate-metasploit/) and everything have changed for me since that day.<br />
**thank you for the inspiration l33t @hdmoore** ..
"My love for scripting and understanding, have done all the rest" ..
![pic](http://i64.tinypic.com/210g9bp.gif)


#### [!] [Jump to readme file index](https://github.com/r00t-3xp10it/resource_files#index)

### Suspicious Shell Activity RedTeam @2019

