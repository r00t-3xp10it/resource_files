---
-- Nmap NSE file-checker.nse - Version 1.6
-- Copy script to: /usr/share/nmap/scripts/file-checker.nse
-- Update db: sudo nmap --script-updatedb
-- executing: nmap --script-help file-checker.nse
---


-- SCRIPT BANNER DESCRIPTION --
description = [[

Author: r00t-3xp10it
NSE script to check/read contents of the selected file/path in target webserver.
This module will search if 'index' exists, and if used --script-args read=true
then file-checker.nse script will read/display the contents of the 'index' file.

This script also gives you the ability to search for a diferent 'index' (files or directory)
using --script-args index=/file-to-search or index=/directory-to-search, or set a diferent
User-agent to send in the ofending tcp packet --script-args agent=<User-agent>
'Default behavior its to search for robots.txt file in webserver'

This script also gives to is users the ability to use the lost '--interactive' nmap
switch, that allow us to interact with the bash shell inside of nmap funtions using:
nmap -sV -Pn -p 80 --script file-checker.nse --script-args "command=/bin/sh -i" <target>
'WARNING: The 'command' argument does not work together with other script arguments'


Some Syntax examples:
nmap -sS -Pn -p 80 --open --script file-checker.nse <target or domain>
nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/etc/passwd" <target or domain>
nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "command=/bin/sh -i" <target or domain>
nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/robots.txt,read=true" <target or domain>
nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "agent=Mozilla/5.0 (compatible; EvilMonkey)" <target or domain>
nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/index.html,read=true" --spoof-mac Apple <target or domain>
nmap -sV -Pn -T4 -iR 400 -p 80 --open --reason --script file-checker.nse --script-args "index=/etc/passwd,read=true" -oN creds.log
nmap -sI -Pn -p 80 --scan-delay 8 --script file-checker.nse --script-args "index=/robots.txt,read=true" <zombie>,<target or domain>

]]

---
-- @usage
-- nmap --script-help file-checker.nse
-- nmap -sS -Pn -p 80 --open --script file-checker.nse <target or domain>
-- nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/etc/passwd" <target or domain>
-- nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "command=/bin/sh -i" <target or domain>
-- nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/robots.txt,read=true" <target or domain>
-- nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "agent=Mozilla/5.0 (compatible; EvilMonkey)" <target or domain>
-- nmap -sS -Pn -p 80 --open --script file-checker.nse --script-args "index=/index.html,read=true" --spoof-mac Apple <target or domain>
-- nmap -sV -Pn -T4 -iR 400 -p 80 --open --reason --script file-checker.nse --script-args "index=/etc/passwd,read=true" -oN creds.log
-- nmap -sI -Pn -p 80 --scan-delay 8 --script file-checker.nse --script-args "index=/robots.txt,read=true" <zombie>,<target or domain>
-- @output
-- PORT   STATE SERVICE
-- 80/tcp open  http
-- | file-checker:
-- |   index: /robots.txt
-- |   STATUS: 200 OK FOUND
-- |     module author: r00t-3xp10it
-- |       user-agent : Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; ko; rv:1.9.1b2) Gecko/20081201 Firefox/3.1b2
-- |
-- | CONTENTS:
-- | # robots.txt of youtube since the time dinosaurs walk the hearth
-- | # This file should be placed into your website webroot directory.
-- |
-- | User-agent: *
-- | Disallow: /SSA/
-- | Disallow: /porn/
-- | Disallow: /login/
-- | Disallow: /cache/
-- | Disallow: /search/
-- | Disallow: /privacy/
-- | Disallow: /includes/
-- | Disallow: /credentials/
-- |_
-- @args search.index   -> The file/path name to search -> Default: /robots.txt
-- @args fakeUser.agent -> The User-agent to send in header request -> Default: iPhone,safari
-- @args contents.read  -> Read contents of the 'index' file selected ? -> Default: false
-- @args local.command  -> intercative bash shell -> Default: false
---

author = "r00t-3xp10it"
license = "Same as Nmap--See http://nmap.org/book/man-legal.html"
categories = {"discovery", "safe"}


-- DEPENDENCIES (lua nse libraries) --
local shortport = require "shortport"
local stdnse = require ('stdnse')
local http = require "http"
local os = require "os"


  -- THE RULE SECTION --
  -- Port rule will only execute if port 80/443 tcp http/https its on open state
  portrule = shortport.port_or_service({80, 443}, "http, https", "tcp", "open")
  -- Seach for string stored in variable @args or use the default ones...
  local index = stdnse.get_script_args(SCRIPT_NAME..".index") or "/robots.txt"
  local command = stdnse.get_script_args(SCRIPT_NAME..".command") or "false"
  local read = stdnse.get_script_args(SCRIPT_NAME..".read") or "false"
  local agent_string = stdnse.get_script_args(SCRIPT_NAME..".agent") or "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; ko; rv:1.9.1b2) Gecko/20081201 Firefox/3.1b2"


    -- THE ACTION SECTION --
    if (command == "false") then
      action = function(host, port)

      -- Manipulate TCP packet 'header' with false information about attacker :D
      local options = {header={}}   --> manipulate 'header' request ..
      options['header']['User-Agent'] = stdnse.get_script_args(SCRIPT_NAME..".agent") or "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; ko; rv:1.9.1b2) Gecko/20081201 Firefox/3.1b2" --> use MAC OSX,Firefox User-agent OR your own...
      options['header']['Accept-Language'] = "en-GB,en;q=0.8,sv" --> use en-GB as attacker default install language
      options['header']['Cache-Control'] = "no-store" -->  Instruct webserver to not write it to disk (do not cache it)
      -- read response from target (http.get)
      local response = http.get(host, port, index, options)

        -- Check if 'index' exist on target webserver
        if (response.status == 200 ) then
          if (read == "true") then
            -- Display return code and index body ...
            return "\n  index: "..index.."\n  STATUS: "..response.status.." OK FOUND\n    module author: r00t-3xp10it\n      user-agent : "..agent_string.."\n\nCONTENTS:\n"..response.body.."\n"
          else
            -- Display only return code (default behavior)...
            return "\n  index: "..index.."\n  STATUS: "..response.status.." OK FOUND\n    module author: r00t-3xp10it\n"
          end

        -- More Error codes displays (NOT FOUND)...
        elseif (response.status == 400 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." BAD REQUEST\n    module author: r00t-3xp10it\n"
        elseif (response.status == 302 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." REDIRECTED\n    module author: r00t-3xp10it\n"
        elseif (response.status == 401 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." UNAUTHORIZED\n    module author: r00t-3xp10it\n"
        elseif (response.status == 404 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." NOT FOUND\n    module author: r00t-3xp10it\n"
        elseif (response.status == 403 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." FORBIDDEN\n    module author: r00t-3xp10it\n"
        elseif (response.status == 503 ) then
          return "\n  index: "..index.."\n  STATUS: "..response.status.." UNAVAILABLE\n    module author: r00t-3xp10it\n"
        else
          -- Undefined error code (NOT FOUND)...
          return "\n  index: "..index.."\n  STATUS: "..response.status.." UNDEFINED ERROR\n    module author: r00t-3xp10it\n"
        end
      end

    else

      -- Execute local system command (args)
      action = function(host, port)
        os.execute(""..command.."")
          return "\n  module author: r00t-3xp10it\n    sys-command: "..command.."\n"
    end
end

