#!/bin/bash

if [ $# -ne 2 ];then
  echo "Usage: `basename $0` idVendor idProduct"
  exit 1
fi


for X in /sys/bus/usb/devices/*; do
    if [ "$1" == "$(cat "$X/idVendor" 2>/dev/null)" -a "$2" == "$(cat "$X/idProduct" 2>/dev/null)" ]
    then
        echo "$X"
        echo "speed: $(cat $X/speed)"
    fi
done
