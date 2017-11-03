#!/bin/sh
mount_dir="/mnt/hdc"
dir1="1"
dir2="2"

dev_path="172.21.98.43:/home/cfyeh/nfs/for_usb_test"

file="1812.mp3"
#file="1.mpg"

#diff_file="/tmp/diff"
diff_file="diff"

count=0;

umount $mount_dir
while [ count ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t nfs -o nolock,tcp $dev_path $mount_dir
	rm -f $mount_dir/$dir2/$file
	cp -f $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	sync
	umount $mount_dir

        echo $count - diff ... $file
	mount -t nfs -o nolock,tcp $dev_path $mount_dir 
	#$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || (echo $count >> /tmp/log.burning && $diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || mv $mount_dir/$dir2/$file $mount_dir/$dir2/$file.$count)
	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || (echo $count >> /tmp/log.burning && mv $mount_dir/$dir2/$file $mount_dir/$dir2/$file.$count)
	sync
	umount $mount_dir
done
