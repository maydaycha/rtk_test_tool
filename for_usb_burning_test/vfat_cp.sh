#!/bin/sh
dev_path="$1"
#dev_path="/dev/sda3"
mount_dir="$2"
#mount_dir="/mnt/hda"
dir1="1"
dir2="2"


#cp_file="/tmp/cp -D"
cp_file="cp"

#diff_file="/tmp/diff"
diff_file="diff"

fs="vfat -o rw,shortname=winnt,iocharset=utf8,umask=0"
#fs="ufsd -o force,rw,nls=utf8,umask=0,noatime"
#fs="ntfs -o rw,iocharset=utf8,umask=0"
#fs="ext3 -o rw"

#file="100.mpg"
file="1.mpg"
#file="1812.mp3"

count=0;

umount $mount_dir
while [ count ]
	do
	let "count += 1"
	echo $1 $count - copy ... $file

	mount -t $fs $dev_path $mount_dir || exit
	rm -f $mount_dir/$dir2/$file
	$cp_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	umount $mount_dir

	echo $1 $count - diff ... $file
	mount -t $fs $dev_path $mount_dir || exit
	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || exit
#	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || (echo $count >> /tmp/log.burning && mv $mount_dir/$dir2/$file $mount_dir/$dir2/$file.$count)
	umount $mount_dir
done

