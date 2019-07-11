## METASPLOIT RESOURCE FILES

<blockquote>Resource scripts provides an easy way for us to automate repetitive tasks in Metasploit. Conceptually they're just like batch scripts, they contain a set of commands that are automatically and sequentially executed when you load the script in Metasploit. You can create a resource script by chaining together a series of Metasploit console commands or by directly embedding Ruby to do things like call APIs, interact with objects in the database, modules and iterate actions.</blockquote>

**This repository contains various resource files to assiste in exploitation or metasploit database related issues.**<br />
![pic](http://i68.tinypic.com/21ovkfm.jpg)

<br />

### DISCLAMER
The resource scripts this repository contains serves as proof of concept (**POC**) of this [article](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files) published on resource files scripting. This repository is designed to demonstrate what resource files [ERB](https://www.offensive-security.com/metasploit-unleashed/custom-scripting/) can accomplish when automating tasks in msfconsole, and they are written to take advantage of multi-hosts-exploitation-scan tasks (manage large databases of hosts) from scanning the local lan for alive hosts, scan attackers input rhosts or scan wan networks in search of rhosts to exploit.


---

<br /><br />

## Mosquito - Automating reconnaissance and brute force attacks

![mosquito_banner](http://i65.tinypic.com/25swl77.png)

<br />

### Index
[1] [Project History](https://github.com/r00t-3xp10it/resource_files#project-history)<br />
[2] [Framework Description](https://github.com/r00t-3xp10it/resource_files#framework-description)<br />
[3] [Framework Dictionary files](https://github.com/r00t-3xp10it/resource_files#framework-dictionary-files)<br />
[4] [Framework Dependencies](https://github.com/r00t-3xp10it/resource_files#framework-dependencies)<br />
[5] [Framework Limitations](https://github.com/r00t-3xp10it/resource_files#framework-limitations)<br />
[6] [Framework Download](https://github.com/r00t-3xp10it/resource_files#framework-download)<br />
[7] [Framework help-update-install-execution](https://github.com/r00t-3xp10it/resource_files#framework-help-update-install-execution)<br />
[8] [Project Referencies url's](https://github.com/r00t-3xp10it/resource_files#referencies)<br />
[9] [Project Acknowledgment](https://github.com/r00t-3xp10it/resource_files#project-acknowledgment)<br />

---
<br /><br />

### Project History
Mosquito.sh (**BASH**) script was written for the purpose of automating the resource files (**ERB**) contained in this [repository](https://github.com/r00t-3xp10it/resource_files). Each resource file is written to allow users to run them in three different ways, from scan the Local Lan, scan user inputs (**RHOSTS/LHOSTS**) or randomly scan the **WAN** network for possible targets to add to metasploit database.

![mosquito_banner](https://i.imgur.com/Ibrvsjk.png)

**WARNING:** In 'Random search WAN for rhosts' Depending of user set LIMMIT value, the scan migth take from 10 to 15 minuts to finish, so its advice to start with default LIMMIT values before testing other timmings.

---
<br /><br />

### Framework Description
Mosquito as first step uses nmap to seach-recon hosts information (or possible targets), then adds all the hosts found to metasploit database to be used in further recon, exploration or brute force jobs carried out later.

![mosquito_banner](http://i66.tinypic.com/v5bix0.png)
![mosquito_banner](http://i63.tinypic.com/2e5pce9.png)

Mosquito allow us to scan Local Lan or WAN networks using nmap (search-recon) and metasploit (recon-exploration-brute-force), but unlike metasploit the scans performed by nmap will use a fake UserAgent (IPhone/Safari) stealth scans (SYN ack) and Cloak scan(s) with decoys (-D decoy_ip,decoy_ip,ME) that turns forensic IDS analysis more dificult to identify the attack.

    stealth technics used to evade IDS analysis
    -------------------------------------------
    nmap -sS [stealth scan using SYN ack]
    nmap -D 188.234.11.254,167.113.24.80,ME [Cloak a scan with decoys]
    nmap --script-args http.useragent="Apache-HttpClient/4.0.3 (java 1.5)" [spoof your UserAgent]

**WARNING:** All this stealth technics will not prevent you beeing caugth, so its advice to **not** use mosquito inside your home network (Local Lan), but insted find a public hotspot to use and abuse mosquito framework.

![mosquito_banner](https://i.imgur.com/84zazDr.png)

Mosquito also allow us to scan-brute-force multiple targets at the same time (multi-tasking) from user inputs to the import of hosts list files containing ip address(s) or randomly seach in WAN for possible targets.

![mosquito_multi_targets](https://i.imgur.com/r3BXpZa.png)

And each valid credentials found (brute-force or exploitation) will spawn a shell session to the remote host in msf prompt.

![mosquito_banner](http://i65.tinypic.com/280v0hc.png)

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

---
<br /><br />

### Framework Dictionary files
Initialy all resource scripts that this project contains are written to allow is users to input dictionary file absoluct path before the scan take place (own dictionary), but mosquito ships with is own set of dictionary files to assist in brute force tasks, and it does not allow is users to input another dictionary file when running mosquito framework.

nevertheless mosquito users can improve existing dictionary(s) by edit them before executing the framework, all dictionary files can be found under project working directory in: 'resource_files/bin/worldlists'.

![mosquito_banner](http://i63.tinypic.com/2u7c87b.png)

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

---
<br /><br />

### Framework Dependencies
|dependencie|actions|install|
|---|---|---|
|zenity|Bash script GUI interfaces|[zenity download](https://help.gnome.org/users/zenity/) * |
|nmap| WAN random search; recon | [nmap download](https://nmap.org/download.html) * |
|metasploit| msf database; recon; exploitation; brute force | [metasploit download](https://www.metasploit.com/download) |
|geoiplookup| hosts geo location | sudo apt-get install geoip-bin * |
|curl| hosts geo location | sudo apt-get install curl * |
|dig| ip address resolver | Linux native installed package ** |
|http-winrm.nse| http winrm recon | mosquito native nse script * |
|freevulnsearch.nse| CVE recon | mosquito native nse script * |

    * ./mosquito.sh -i = to install all packages/scripts/modules
    ** Linux native installed package = no need to install it

**Hint:** All mosquito dependencies can be easy installed by runing: **sudo ./mosquito.sh -i**<br />
Adicionaly to the dependencies described above, diferent resource scripts requires diferent msf auxiliarys
or nmap nse adicional scripts installed, the -i switch in mosquito allow us to download/install all that extra modules fast and easy.

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

---
<br /><br />

### Framework Limitations
**a)** mosquito only accepts ip addr inputs, not domain names<br />
**b)** brute forcing takes time, use 'CTRL+C' to skip current task(s)<br />
**c)** mosquito dicionarys can be found in resource_files/bin/worldlists<br />
**d)** find valid credentials sometimes fails to spawn a shell<br />
**e)** multiple sessions open migth slowdown your pc<br />

**Hint:** This resource scripts requires that the msf database to be empty of hosts and services data. Thats the main reason why this scripts creates a new workspace named **'mosquito'** and stores all data inside that workspace while working, then the resource script deletes the **'mosquito'** workspace in the end of execution.

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

---
<br /><br />

### Framework Download
```
[download]   git clone https://github.com/r00t-3xp10it/resource_files.git
[permitions] cd resource_files && find ./ -name "*.sh" -exec chmod +x {} \;
```
![mosquito_banner](http://i67.tinypic.com/b6es7l.png)

### Framework help-update-install-execution

    [help]    sudo ./mosquito.sh -h
![mosquito_banner](http://i63.tinypic.com/wa652q.png)

    [update]  sudo ./mosquito.sh -u
![mosquito_banner](http://i65.tinypic.com/294mdja.png)

    [install] sudo ./mosquito.sh -i
![mosquito_banner](http://i67.tinypic.com/a59l50.png)

    [execute] sudo ./mosquito.sh
![mosquito_banner](http://i65.tinypic.com/25swl77.png)

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

---
<br /><br />

### Referencies
[1] [Project home page](https://github.com/r00t-3xp10it/resource_files)<br />
[2] [Project wiki - dependencies](https://github.com/r00t-3xp10it/resource_files/wiki/Offensive-Resource_Files-%7C-Dependencies)<br />
[3] [offensive resource script - geo_location.rc](https://github.com/r00t-3xp10it/resource_files/wiki/Offensive-Resource_Files--%7C-Geo_Location)<br />
[4] [offensive resource script - post_exploitation.rc](https://github.com/r00t-3xp10it/resource_files/wiki/post_exploitation.rc-%7C-offensive-resource-script)<br />
[5] [hacking-material-books - metasploit_resource_files](https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md#metasploit-resource-files)<br />

<br />

### Project Acknowledgment
@HD Moore - metasploit framework<br />
@fyodor - nmap framework<br />
@Mathias Gut - freevulnsearch.nse script<br />
@Sean Warnock - http-winrm.nse script<br />

[jump to top](https://github.com/r00t-3xp10it/resource_files#index)

<br />

## Suspicious Shell Activity redteam@2019
