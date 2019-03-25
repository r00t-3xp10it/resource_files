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
   |_ OS:$OS DISTRO:$DiStRo VERSION:$ver


!
sleep 1
echo -n "${GreenF}[+]${white} Do you wish to install (y/n): "${Reset}; read op
if [ "$op" = "y" ] || [ "$op" = "Y" ]; then

    Colors;
    echo ${BlueF}[*] "----------------------------------------"${Reset};
    echo ${BlueF}[*]${white} "Locate msfdb enum_protections.rb path .."${Reset};
    aV_path=$(locate modules/post/windows/recon | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $aV_path/enum_protections.rb"${Reset};
    sleep 2

       if [ -e "$aV_path/enum_protections.rb" ]; then
          echo ${GreenF}[*]${white} "Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${BlueF}[*]${white} "Copy module to: $aV_path/enum_protections.rb"${Reset};
          sudo cp enum_protections.rb $aV_path/enum_protections.rb
          fresh = "yes"
          sleep 2
       fi

    echo ${BlueF}[*]${white} "Locate msfdb SCRNSAVE_T1180_persistence.rb path .."${Reset};
    t1180_path=$(locate modules/post/windows/escalate | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
    sleep 2

       if [ -e "$t1180_path/SCRNSAVE_T1180_persistence.rb" ]; then
          echo ${GreenF}[*]${white} "Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${BlueF}[*]${white} "Copy module to: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
          sudo cp SCRNSAVE_T1180_persistence.rb $t1180_path/SCRNSAVE_T1180_persistence.rb
          fresh = "yes"
          sleep 2
       fi

    echo ${BlueF}[*]${white} "Locate msfdb linux_hostrecon.rb path .."${Reset};
    Linux_path=$(locate modules/post/linux/gather | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $Linux_path/linux_hostrecon.rb"${Reset};
    sleep 2

       if [ -e "$Linux_path/linux_hostrecon.rb" ]; then
          echo ${GreenF}[*]${white} "Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${BlueF}[*]${white} "Copy module to: $Linux_path/linux_hostrecon.rb"${Reset};
          sudo cp linux_hostrecon.rb $Linux_path/linux_hostrecon.rb
          fresh = "yes"
          sleep 2
       fi


    ## Updating msfdb
    if [ "$fresh" = "yes" ]; then
       echo ${YellowF}[*]${white} "Updating msf database .."${Reset};
       sudo service postgresql start
       sudo msfdb reinit
       sudo msfconsole -x 'db_status;reload_all;exit -y'
    fi



    echo ${BlueF}[*]${white} "Locate nmap nse freevulnsearch.nse path .."${Reset};
    sudo cp freevulnsearch.nse /usr/share/nmap/scripts/freevulnsearch.nse
    echo ${BlueF}[*]${white} "Path: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
    sleep 2

       if [ -e "/usr/share/nmap/scripts/freevulnsearch.nse" ]; then
          echo ${GreenF}[*]${white} "Nmap nse script found in database => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
          sleep 2
          echo ${YellowF}[*]${white} "Updating nse database .."${Reset};
          sudo nmap --script-updatedb
       fi

    echo ${BlueF}[*] "----------------------------------------"${Reset};
    echo ${BlueF}[*]${white} "All post-modules are ready to be used."${Reset};

else

    Colors;
    echo ${RedF}[x]${white} "Aboting tasks .."${Reset};

fi

exit

