## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

**This repository contains various resource files to assiste in post-exploitation or metasploit database related issues.**
#### [!] [Please read the article about rc scripting here:](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)

<br />

## USE SETG GLOBAL VARIABLES TO CONFIG RC SCRIPTS

![pic](hgft)

Many of the this brute force rc scripts are written to accept user inputs (setg global variables)

setg RANDOM 300 | seach in 300 rhosts | msfconsole -q -x 'setg RANDOM 300;resource /root/msysql_brute.rc' |
setg RANDOM_HOSTS true | search in WAN for rhosts | msfconsole -q -x 'setg RANDOM_HOSTS true;resource /root/msysql_brute.rc' |
setg RHOSTS | rhosts delimited by empty spaces | msfconsole -q -x 'setg RHOSTS 10.10.10.1 10.10.10.2;resource /root/msysql_brute.rc' |
setg USERPASS_FILE | absoluct path to dicionary file | msfconsole -q -x 'setg USERPASS_FILE /root/dic.txt;resource /root/msysql_brute.rc' |

<br />

#### [!] [Use resource-trigger.sh to test rc scripts:](https://github.com/r00t-3xp10it/resource_files/blob/master/aux/resource-trigger.sh)
