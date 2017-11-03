#!/bin/sh
dev_path="$1"
#dev_path="/dev/sda3"
mount_dir="$2"
#mount_dir="/mnt/hda"
dir1="1"
dir2="2"
fs="ext3"

file="1.mpg"
#file="100.mpg"
#file="1812.mp3"

#cp_file="/tmp/cp -D"
cp_file="cp"

#diff_file="/tmp/diff"
diff_file="diff"
count=0;

umount $mount_dir
while [ count ]
	do
	let "count += 1"
	echo $1 $count - copy ... $file

	mount $dev_path $mount_dir || exit
	rm -f $mount_dir/$dir2/$file
	$cp_file -f $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	umount $mount_dir

	echo $1 $count - diff ... $file
	mount $dev_path $mount_dir || exit
	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || echo $count >> /tmp/log.burning
	#diff $mount_dir/$dir1/$file $mount_dir/$dir2/$file 
	umount $mount_dir
done

