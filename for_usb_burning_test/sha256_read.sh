#!/bin/sh
dev_path="$1"
#dev_path="/dev/sda3"
mount_dir="$2"
#mount_dir="/mnt/hda"
dir1="1"
dir2="2"
fs="vfat"

file="1.mpg"
#file="1812.mp3"

sha1_file="sha256sum"
count=0;

umount $mount_dir
while [ count ]
	do
	let "count += 1"
	
        echo $1 $count - sha1 ... $file
        mount -t vfat -o rw,shortname=winnt,iocharset=utf8,umask=0 $dev_path $mount_dir || exit
        $sha1_file $mount_dir/$dir1/$file || echo $count >> /tmp/log.burning
        umount $mount_dir
done
                                                
