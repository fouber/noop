#!/bin/bash

while true
do
    pppoe-stop 2>&1 1>/dev/null
    pppoe-start 2>&1 1>/dev/null
    wget -qO- http://1212.ip138.com/ic.asp | grep body | awk -vtime=`date +%H:%M:%S` -F '\[|\]' '{print "["time"] IP="$2}'
done
