#!/usr/bin/env bash

# SOURCE: https://gist.github.com/kiki67100/5e1568ac783e8e4942b672f1090db2cd

### Script to install xquartz and set the DISPLAY variable correctly, find the listen port and add current ip to connect to X11.

#skip if you want, install xquartz
# brew cask reinstall xquartz
#get ip
IP=$(ifconfig|grep -E inet.*broad|awk '{ print $2; }')
#open XQuartz
open -a XQuartz &
#Go to preference Security check allow network, restart :
read -p "Go to preference Security check allow network and press a key to continue"
kill -3 $(ps aux|grep -i Xquartz|awk '{ print $2} ' );
open -a XQuartz &
read -p "Press a key when XQuartz is started"
#Find good port
p=0;for port in $(seq 0 10);do echo "Check :$((6000+$p)) (:$p)";  nc -w0 127.0.0.1 $((6000+$p)) && DISPLAY="$IP:$p"; let p=p+1;  done;
#add xhost
echo "DISPLAY IS $DISPLAY";
/usr/X11/bin/xhost + $IP

export DISPLAY=$DISPLAY
#Lauch your display

#docker run -e DISPLAY=$DISPLAY jess/firefox
