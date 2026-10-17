##
# MP3 Reporter v1.0
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#
# My SVS Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
# TCL Mailing list - http://mc.purehype.net:81/maillist/
##

##
# This is an addon script that does nothing special other than 
# reporting file found via the CTCP MP3 (spr bassed irc servers) to a 
# web based search engine.  Currently I know of only 1 web based search 
# engine compatable with this script, and that's because I made it.  
# You can utalize this search engine at 
# http://www.purehype.net:2001/mp3/.
#
# Running this script helps out the web bassed search engine greatly 
# for without any items in a database, the database is useless.  So, in 
# running this I thank you.  This script will report the mp3's, it 
# doesn't download them and send them or anything like that, so it 
# doesn't eat up much bandwith.  Running this script also helps out the 
# specific mp3 channel, the more files a channel has... the more 
# results will be found on the search engine in turn the more users 
# utalize that channel for there mp3 needs.
#
# All mp3's reported to the mp3 server do expire after 4 weeks of age, 
# so that it's always up to date.
##

##
# HISTORY  ( <Fixed by> - [Found by] - <Info> )
##
# v1.0 (02.12.02)
#  MC_8 - - Inital Beta Release.
##

##
# COMMANDS (dcc)
##
# chanset <#channel> <-/+>mc.mp3reporter.ignorechan
#   Setting this enables (+) or disables (-) the ignore of CTCP MP3's 
#   from the particular channel.  All channels will be activly watched 
#   by default unless told otherwise here.
##

##
# Settings
##

# What server do you want to report mp3's to?  As of right now 
# (02-12-02), there is only 1 web search engine server that supports 
# this (www.purehype.net), and that's only because I made it.
set mc_mp3rep(server) "www.purehype.net"

# What port is this web based mp3 search engine on?  www.purehype.net's 
# is currently on 2001.
set mc_mp3rep(port) "2001"

# Once an hour the script will post the queued mp3's it has found to 
# the web bassed search engine.  The setting should be the minute of 
# the hour for witch this should happen.
# examples:
#  set mc_mp3rep(time) 0   ;#This is at x:00, on the hour.
#  set mc_mp3rep(time) 10  ;#This is at x:10, 10 min's past the hour.
#  set mc_mp3rep(time) 32  ;#This is at x:32, 32 min's past the hour.
#  set mc_mp3rep(time) 55  ;#This is at x:55, 55 min's past the hour 
#                           (or better known as 5 min's till the next 
#                            hour).
set mc_mp3rep(time) 3


## MC SVS (Script Version Service) v2.0 ##
# [0=no/1=yes] Do you want the bot to connection to MC_8's SVS to see
# if there are newer versions of this script avilable?  It will only
# tell you -- It's up to you to get the newest version (I decided not
# to auto update the code, there may be new features in the newest
# script that may require your attention).
set mc_mp3rep(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_mp3rep(svs:check) 0   ;#This is at Midnight
#  set mc_mp3rep(svs:check) 5   ;#This is at 5am
#  set mc_mp3rep(svs:check) 13  ;#This is at 1pm
#  set mc_mp3rep(svs:check) 23  ;#This is at 11pm
set mc_mp3rep(svs:check) 3

# Upon finding a newer version of this script, who do you want this
# script to send a note to telling them of this newer version? If more
# than 1 user is to be notified, seperate each user with a ' ' (space).
set mc_mp3rep(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or
# just stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_mp3rep(svs:stableonly) 0


##
# Edit no further, tcl coding below.
##

# [programmer setting] What's the GET URI for the web based mp3 search 
# engine?  This goes in direct relation to mc_mp3rep(http:report).
set mc_mp3rep(location) "/mp3/index.cgi"

# The query string that should be passed, action=add is already 
# prepended.
set mc_mp3rep(query) "mp3=%mp3&nick=%nick&chan=%chan&server=%server"

#Script:mc_mp3rep

set mc_mp3rep(script)      "MP3 Reporter"
set mc_mp3rep(version)     "v1.0"
set mc_mp3rep(svs:script)  "mp3reporter"
set mc_mp3rep(svs:version) "001000000000"
set mc_mp3rep(svs:server)  "mc.purehype.net"
set mc_mp3rep(svs:port)    "81"
set mc_mp3rep(svs:get)     "/"
set mc_mp3rep(svs:query)   "svs=$mc_mp3rep(svs:script)&version=$mc_mp3rep(svs:version)"

if {$numversion < "1050500"} {
 putlog "$mc_mp3rep(script) $mc_mp3rep(version) by MC_8 will only work on eggdrop 1.5.5 or greater."
 putlog "$mc_mp3rep(script) $mc_mp3rep(version)  will not work with eggdrop $version."
 putlog "$mc_mp3rep(script) $mc_mp3rep(version)  not loaded."
 return 1
}

setudef flag mc.mp3reporter.ignorechan

proc mc:mp3rep:error {bindproc error {arg ""}} {
 global mc_mp3rep version lastbind
 putlog "Error in script $mc_mp3rep(script) $mc_mp3rep(version)."
 putlog "        Last bind: $lastbind"
 putlog "        Procedure: $bindproc"
 putlog "             Args: $arg"
 putlog "  Eggdrop version: $version"
 putlog "      TCL version: [info tclversion]"
 putlog "*** Please tell MC_8 about this BUG!  Visit        "
 putlog "*** http://mc.purehype.net:81/bugzilla/ to do so.  "
 putlog "*** Please include the next line in the bug report."
 error $error
}

proc mc:mp3rep:errchk {command arg} {
 if {[catch {eval $command $arg} return]} {
  mc:mp3rep:error $command $return $arg; return 0
 }; return $return
}

bind ctcp - MP3 mc:mp3rep:ctcp
# Doing the pub to catch them broken servers.
bind pub - \001MP3 mc:mp3rep:pub:ctcp:mp3
proc mc:mp3rep:pub:ctcp:mp3 {nick uhost hand chan arg} {mc:mp3rep:ctcp $nick $uhost $hand $chan MP3 $arg}

proc mc:mp3rep:ctcp {nick uhost hand chan key arg} {
 return [mc:mp3rep:errchk mc:mp3rep:ctcp_ [list $nick $uhost $hand $chan $key $arg]]
}
proc mc:mp3rep:ctcp_ {nick uhost hand chan key arg} {
 global mc_mp3rep server
 if {(![mc:mp3rep:validchan $chan]) || ([mc:mp3rep:chanflag $chan mc.mp3reporter.ignorechan])} {return 0}
 lappend mc_mp3rep(::list::) [list $nick $chan $arg $server]
 return 0
}

foreach bind [binds mc:mp3rep:report] {unbind [lindex $bind 0] [lindex $bind 1] [lindex $bind 2] [lindex $bind 4]}
if {($mc_mp3rep(time) > "23") || ($mc_mp3rep(time) < "0")} {set mc_mp3rep(time) 00} \
elseif {[string length $mc_mp3rep(time)] == "1"} {set mc_mp3rep(time) 0$mc_mp3rep(time)}
bind time - "$mc_mp3rep(time) *" mc:mp3rep:report

proc mc:mp3rep:report {{args ""}} {
 return [mc:mp3rep:errchk mc:mp3rep:report_ [list $args]]
}
proc mc:mp3rep:report_ {{args ""}} {
 global mc_mp3rep
 if {(![info exists mc_mp3rep(::list::)]) || ($mc_mp3rep(::list::) == "")} {return 0}
 if {[catch {socket -async $mc_mp3rep(server) $mc_mp3rep(port)} sid]} {
  putlog "$mc_mp3rep(script) Error:  $sid"
  return 0
 }
 fconfigure $sid -blocking 0 -buffering line
 set query [list action=add]
 foreach entry $mc_mp3rep(::list::) {
  set nick [lindex $entry 0]; set chan [lindex $entry 1]; set mp3 [lindex $entry 2]; set server [lindex $entry 3]
  set temp(query) [mc:mp3rep:replace $mc_mp3rep(query) [list %mp3    [mc:mp3rep:httpd_encode $mp3] \
                                                             %nick   [mc:mp3rep:httpd_encode $nick] \
                                                             %chan   [mc:mp3rep:httpd_encode $chan] \
                                                             %server [mc:mp3rep:httpd_encode $server]]]
  lappend query $temp(query)
 }; set query [join $query &]
 puts $sid "POST $mc_mp3rep(location) HTTP/1.0\
          \nHost: $mc_mp3rep(server):$mc_mp3rep(port)\
          \nContent-Length: [string length $query]\n\n${query}"
 flush $sid; close $sid
 set length [llength $mc_mp3rep(::list::)]
 if {$length == "1"} {set s ""} else {set s s}
 putlog "$mc_mp3rep(script):  Reported $length file$s to http://$mc_mp3rep(server):$mc_mp3rep(port)$mc_mp3rep(location)"
 set mc_mp3rep(::list::) ""
}

# v1.0+mc.mp3reporter
# Special chanflag version for this script, since mp3 servers
# spit out so much bandwidth... this version cuts 30k microseconds
# off the cpu.  The chanflag from mc.moretools is still good and
# will be recomended rather than this one.
proc mc:mp3rep:chanflag {channel flag} {
 if {[lsearch -exact [string tolower [channel info $channel]] +[string tolower $flag]] == "-1"} {return 0}; return 1
}

# v1.1
proc mc:mp3rep:replace {text subs} {
 if {![catch {string map -nocase $subs $text} output]} {return $output}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- {([\\\*\+\?\{\}\,\(\)\:\[\]\.\^\$\=\!\|])} [lindex $subs $i] {\\\1} temp(temp)
  regsub -all -- $temp(temp) $text [lindex $subs [expr $i+1]] text
 }; return $text
}

# v1.1
proc mc:mp3rep:httpd_encode {text} {
 regsub -all {\%} $text "%25" text; regsub -all { } $text "+" text
 set i [string length $text]
 while {([regexp {[^a-zA-Z0-9+%]} $text toh]) && ($i > 0)} {
  incr i -1; scan "$toh" %c dec
  regsub -all -- {([\\\*\+\?\{\}\,\(\)\:\[\]\.\^\$\=\!\|])} $toh {\\\1} toh
  regsub -all -- $toh $text "%[format %X $dec]" text
 }; return $text
}

# v1.0
# This is 1k microseconds faster than core 'validchan'.
proc mc:mp3rep:validchan {chan} {
 if {[lsearch -exact [string tolower [channels]] [string tolower $chan]] == "-1"} {return 0}; return 1
}

## SVS v2.0
if {(![info exists mc_mp3rep(svs:enabled)]) ||
    (![regexp -- {^(0|1)$} $mc_mp3rep(svs:enabled)])} {set mc_mp3rep(svs:enabled) 0}
if {(![info exists mc_mp3rep(svs:check)]) ||
    ([regexp -- {[^0-9]} $mc_mp3rep(svs:check)])} {set mc_mp3rep(svs:check) 0}
if {![info exists mc_mp3rep(svs:notify)]} {set mc_mp3rep(svs:notify) $owner}
if {(![info exists mc_mp3rep(svs:stableonly)]) ||
    (![regexp -- {^(0|1)$} $mc_mp3rep(svs:stableonly)])} {set mc_mp3rep(svs:stableonly) 0}
foreach bind [binds mc:mp3rep:svs:time] {
 unbind [lindex $bind 0] [lindex $bind 1] [lindex $bind 2] [lindex $bind 4]
}
foreach command [info commands mc:mp3rep:svs:time] {rename $command ""}
if {$mc_mp3rep(svs:enabled)} {
 if {($mc_mp3rep(svs:check) > "23") || ($mc_mp3rep(svs:check) < "0")} {set mc_mp3rep(svs:check) 00}
 if {[string length $mc_mp3rep(svs:check)] == "1"} {set mc_mp3rep(svs:check) 0$mc_mp3rep(svs:check)}
 bind time - "00 $mc_mp3rep(svs:check) *" mc:mp3rep:svs:time
 proc mc:mp3rep:svs:time {{args ""}} {
  global mc_mp3rep
  if {[catch {socket -async $mc_mp3rep(svs:server) $mc_mp3rep(svs:port)} sid]} {;\
   putlog "SVS Error\[$mc_mp3rep(svs:script)/$mc_mp3rep(svs:version)\]:  $sid"
   return 1
  }
  fconfigure $sid -blocking 0 -buffering line
  set tout [after 60000 "mc:mp3rep:svs:interface $sid timeout"]
  fileevent $sid readable "mc:mp3rep:svs:interface $sid $tout"
  puts $sid "GET $mc_mp3rep(svs:get)?$mc_mp3rep(svs:query) HTTP/1.0\
           \nHost: $mc_mp3rep(svs:server)\n"
  flush $sid
 }
}
proc mc:mp3rep:svs:interface {sid tout} {
 global mc_mp3rep
 if {$tout == "timeout"} {
  putlog "SVS Warning\[$mc_mp3rep(svs:script)/$mc_mp3rep(svs:version)\]:  SVS Server timed out."
  close $sid
  return 0
 }; after cancel $tout
 set temp 0
 while {![eof $sid]} {
  gets $sid get
  if {$temp < "2"} {
   if {$get == ""} {incr temp; if {$temp == "1"} {set temp 2}}
   continue
  }; if {$get == ""} {continue}
  switch -- [lindex $get 0] {
   003 {
    set reply [lrange $get 1 end]
    if {[lindex $reply 0] != $mc_mp3rep(svs:script)} {
     putlog "SVS Error\[$mc_mp3rep(svs:script)/$mc_mp3rep(svs:version)\]:  SVS Server sent wrong info, got [lindex $reply 0]"
     break   
    }
    if {$mc_mp3rep(svs:stableonly)} {
     set temp [string range $mc_mp3rep(svs:version) 0 8]999
    } else {set temp [string range $mc_mp3rep(svs:version) 0 11]}
    if {[lindex $reply 1] > $temp} {
     set note [lindex $reply 5]
     regsub -- %0 $note [lindex $reply 0] note
     regsub -- %1 $note [lindex $reply 1] note
     regsub -- %2 $note [lindex $reply 2] note
     regsub -- %3 $note [lindex $reply 3] note
     regsub -- %4 $note [lindex $reply 4] note
     regsub -- %version $note $mc_mp3rep(version) note
     foreach to [split $mc_mp3rep(svs:notify) ",; "] {
      if {$to == ""} {continue}
      regsub -- %nick $note $to outnote
      if {[string match *$outnote* [set unotes [notes $to -[notes $to]]]]} {
       set temp 0
       foreach unote $unotes {
        if {$outnote == [lindex $unote 2]} {set temp 1; break}
       }; if {$temp} {continue}
      }
      switch -- [sendnote SVS $to $outnote] {
       0 {
        if {![validuser $notify]} {set x "invalid user"} else {set x "unknown error"}
        putlog "SVS Error\[$mc_mp3rep(svs:script)/$mc_mp3rep(svs:version)\]:  Trying to send note to $to, $x."
       }
       3 {putlog "SVS Error\[$mc_mp3rep(svs:script)/$mc_mp3rep(svs:version)\]:  Trying to send note to $to, notebox too full!"}
      }
     }
    }
   }
  }
 }; close $sid
}
## ^

putlog "$mc_mp3rep(script) $mc_mp3rep(version) by MC_8 loaded."