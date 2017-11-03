#!/bin/sh
dev_path="$1"
#dev_path="/dev/sda1"
mount_dir="$2"
#mount_dir="/mnt/hda"
dir1="1"
dir2="2"

file="1812.mp3"
diff_file="/tmp/diff"
count=0;

while [ count ]
	do
	let "count += 1"
	echo $1 $count - copy ... $file

	mount $dev_path $mount_dir || exit
	rm -f $mount_dir/$dir2/$file
	cp -f $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	umount $mount_dir

	echo $1 $count - diff ... $file
	mount $dev_path $mount_dir || exit
	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || echo $count >> /tmp/log.burning
	#diff $mount_dir/$dir1/$file $mount_dir/$dir2/$file 
	umount $mount_dir
done

