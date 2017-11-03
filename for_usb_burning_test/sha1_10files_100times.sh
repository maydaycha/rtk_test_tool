#!/bin/sh
count=0
tmp=0
file_num=10
limit=1000000
src_file="1812.mp3"
src_dir="/tmp/usbmounts/test"
sha1_file="/tmp/sha1sum_mips"

while [ "$count" != "$limit" ]
	do
	count=$(($count+1))
	tmp=$(($count % $file_num))
	echo $count - count $src_dir/$src_file.$tmp sha1...
	ls -al $src_dir/$src_file.$tmp
	$sha1_file $src_dir/$src_file.$tmp
done
