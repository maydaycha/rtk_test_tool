#!/bin/sh
count=0
limit=50000
src_dir="./1"
src_file="1812.mp3"
dst_dir="/tmp/usbmounts/sda2/test"

mkdir -p $dst_dir
while [ "$count" != "$limit" ]
	do
	count=$(($count+1))
        echo $count - copy file...
	cp $src_dir/$src_file $dst_dir/$src_file.$count
done
