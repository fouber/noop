#!/bin/bash

while true
do
    pppoe-start 2>&1 1>/dev/null
    wget -qO- http://1212.ip138.com/ic.asp | grep body | awk -F '\[|\]' '{print $2}'
    pppoe-stop 2>&1 1>/dev/null
done
