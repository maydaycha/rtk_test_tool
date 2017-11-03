#!/bin/sh
dev_path1="/dev/sda3"
mount_dir1="/tmp/usbmounts/sda3"
dir1="1"

dev_path2="/dev/sdb1"
mount_dir2="/tmp/usbmounts/sdb1"
dir2="2"

#file="1812.mp3"
file="1.mpg"
diff_file="/tmp/diff"
count=0;

while [ count ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t vfat $dev_path1 $mount_dir1
	mount -t vfat $dev_path2 $mount_dir2
	rm -f $mount_dir2/$dir2/$file
	cp -f $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2

        echo $count - diff ... $file
	mount -t vfat $dev_path1 $mount_dir1
	mount -t vfat $dev_path2 $mount_dir2
	$diff_file $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2
done
