#!/bin/sh
#
# variable declarations _________________________________
#                                                        |
OS=`uname`                                               # grab OS
ver="1.0"                                                # toolkit version
DiStRo=`awk '{print $1}' /etc/issue`                     # grab distribution -  Ubuntu or Kali
IPATH=`pwd`                                              # grab install.sh install path
# _______________________________________________________|


# -----------------------------------
# Colorise shell Script output leters
# -----------------------------------
Colors() {
Escape="\033";
  white="${Escape}[0m";
  RedF="${Escape}[31m";
  GreenF="${Escape}[32m";
  YellowF="${Escape}[33m";
  BlueF="${Escape}[34m";
  CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}


Colors;
#
# BANNER DISPLAY
#
clear
echo ${BlueF}
cat << !

   ╔──────────────────────────────────────────────────╗
   |        "install.sh - configuration script"       |
   | Install all post-modules of post_exploitation.rc |
   ╠──────────────────────────────────────────────────╝
   |_ OS:$OS DISTRO:$DiStRo PATH:$IPATH


!
sleep 1
echo -n "${GreenF}[+]${white} Do you wish to install post modules (y/n): "${Reset}; read op
if [ "$op" = "y" ] || [ "$op" = "Y" ]; then
count="0"

    Colors;
    echo ${BlueF}[*] "----------------------------------------"${Reset};
    echo ${BlueF}[*]${white} "Query msfdb for enum_protections.rb installation .."${Reset};
    aV_path=$(locate modules/post/windows/recon | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${YellowF}[i]${white} "Path: $aV_path/enum_protections.rb"${Reset};
    sleep 2

       if [ -e "$aV_path/enum_protections.rb" ]; then
          echo ${GreenF}[*]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x]${white} "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${BlueF}[*]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 1
          echo ""
          sudo rm -f enum_protections.rb
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/enum_protections.rb
          echo ${BlueF}[*]${white} "Copy module to: $aV_path/enum_protections.rb"${Reset};
          sleep 2
          sudo cp $IPATH/enum_protections.rb $aV_path/enum_protections.rb
          fresh="yes"
          count=$(( $count + 1 ))
       fi

    echo ${BlueF}[*]${white} "Query msfdb for SCRNSAVE_T1180_persistence.rb installation .."${Reset};
    t1180_path=$(locate modules/post/windows/escalate | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${YellowF}[i]${white} "Path: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
    sleep 2

       if [ -e "$t1180_path/SCRNSAVE_T1180_persistence.rb" ]; then
          echo ${GreenF}[*]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x]${white} "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${BlueF}[*]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 2
          echo ""
          sudo rm -f SCRNSAVE_T1180_persistence.rb
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/SCRNSAVE_T1180_persistence.rb
          echo ${BlueF}[*]${white} "Copy module to: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
          sleep 2
          sudo cp $IPATH/SCRNSAVE_T1180_persistence.rb $t1180_path/SCRNSAVE_T1180_persistence.rb
          fresh="yes"
          count=$(( $count + 1 ))
       fi

    echo ${BlueF}[*]${white} "Query msfdb for linux_hostrecon.rb installation .."${Reset};
    Linux_path=$(locate modules/post/linux/gather | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${YellowF}[i]${white} "Path: $Linux_path/linux_hostrecon.rb"${Reset};
    sleep 2

       if [ -e "$Linux_path/linux_hostrecon.rb" ]; then
          echo ${GreenF}[*]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x]${white} "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${BlueF}[*]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 2
          echo ""
          sudo rm -f linux_hostrecon.rb
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/linux_hostrecon.rb
          echo ${BlueF}[*]${white} "Copy module to: $Linux_path/linux_hostrecon.rb"${Reset};
          sleep 2
          sudo cp $IPATH/linux_hostrecon.rb $Linux_path/linux_hostrecon.rb
          fresh="yes"
          count=$(( $count + 1 ))
       fi


    ## Updating msfdb
    if [ "$fresh" = "yes" ]; then
       echo ${YellowF}[i]${white} "Completed: [ ${GreenF}$count${white} ] Module(s) Installation(s) .."${Reset};
       sleep 1
       echo ${BlueF}[*]${white} "Please wait, Updating msf database .."${Reset};
       echo ""
       sudo service postgresql start
       #sudo msfdb reinit
       sudo msfconsole -q -x 'db_status;reload_all;exit -y'
       echo ""
    fi



    echo ${BlueF}[*]${white} "query nmap nse freevulnsearch.nse installation .."${Reset};
    sleep 2
    echo ${YellowF}[i]${white} "Path: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
    sleep 1
    if [ -e "/usr/share/nmap/scripts/freevulnsearch.nse" ]; then
       echo ${GreenF}[*]${white} "Nmap nse script found in database => ${GreenF}(no need to install)"${Reset};
       sleep 2
    else
       echo ${RedF}[x]${white} "Nmap nse script NOT found in database."${Reset};
       sleep 2
       echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
       sleep 2
       echo ""
       sudo rm -f freevulnsearch.nse
       sudo wget https://raw.githubusercontent.com/OCSAF/freevulnsearch/master/freevulnsearch.nse
       echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
       sleep 2
       sudo cp $IPATH/freevulnsearch.nse /usr/share/nmap/scripts/freevulnsearch.nse
       echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};
       sudo nmap --script-updatedb
    fi



    echo ${BlueF}[*] "----------------------------------------"${Reset};
    echo ${BlueF}[*]${white} "All post-modules are ready to be used."${Reset};

else

    Colors;
    echo ${RedF}[x]${white} "Aborting tasks .."${Reset};

fi

    if [ "$fresh" = "yes" ]; then
       sudo service postgresql stop
    fi

exit

