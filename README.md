## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**<br />
![pic](http://i68.tinypic.com/21ovkfm.jpg)

#### [!] Please read this article about Resource Files scripting [here](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

<br />

### REMARK
This brute force resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new workspace named **'redteam'** and stores all the data inside that workspace while working, then the resource script deletes the **'redteam'** workspace in the end of execution. (This action allow us to mantain the attacker *default workspace database intact). The only script that does not create **redteam** workspace its **manage_db.rc**

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

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

---

<br /><br /><br />

#### EXAMPLE

**Step-By-Step how to download/run 'brute_force.rc' script**<br />
1º download the resource script to your **/root** folder<br />

      sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/brute_force.rc

2º start postgresql service (**local machine**)<br />

      sudo service postgresql start

3º run brute_force.rc resource script to search hosts in WAN (**limmit the search to 200 hosts**)<br />

      sudo msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 200;resource /root/brute_force.rc'

### REMARK
This brute force resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new workspace named **'redteam'** and stores all the data inside that workspace while working, then the resource script deletes the **'redteam'** workspace in the end of execution. (This action allow us to mantain the attacker *default workspace database intact).

How to instruct this scripts to export **redteam** workspace database to a local file at the end of execution? **(database.xml)**<br />

      msfconsole -q -x 'setg SAVE_DB true;setg RANDOM_HOSTS true;setg LIMMIT 200;resource /root/brute_force.rc'

This database.xml file can now be **'imported'** to your *default workspace with the follow command:

      sudo msfconsole -q -x 'db_import /root/database.xml'

### REMARK
importing this database.xml files **appends** data to your *default workspace database making it larger.<br />
It does **'not'** delete any entries that you have before on your *default workspace database (it only appends data).

#### [!] Jump to readme file index (beginning) [here](https://github.com/r00t-3xp10it/resource_files#metasploit-resource-files)

<br /><br />

### CREDITS

About 10 years ago (2009) I heard the creator of metasploit say:**automation is the pentesters game**.<br />
Days later this statement led me to read this article [rapid7-@hdmoore](https://blog.rapid7.com/2011/12/08/six-ways-to-automate-metasploit/)..<br/>

**thank you for the inspiration l33t @hdmoore** ..
"My love for scripting and understanding have done all the rest" ..
![pic](http://i64.tinypic.com/210g9bp.gif)


### Suspicious Shell Activity RedTeam @2019

