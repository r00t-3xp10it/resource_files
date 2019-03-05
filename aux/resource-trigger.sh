#!/bin/sh

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
echo ${RedF}[x]${white} This aux script belongs to resource_files github article.${Reset};
echo ${YellowF}[i]${white} https://github.com/r00t-3xp10it/hacking-material-books/blob/master/metasploit-RC%5BERB%5D/metasploit_resource_files.md${Reset};

exit
