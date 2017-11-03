#!/bin/sh
host1="host2"
part1="disc"
mount_dir="/mnt/hdd"
dir1="1"
dir2="2"

dev_path="/dev/scsi/$host1/bus0/target0/lun0/$part1"
file="1812.mp3"
#file="install"
diff_file="/tmp/diff"
count=0;

while [ count ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t vfat $dev_path $mount_dir
	rm -f $mount_dir/$dir2/$file
	cp -f $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	umount $mount_dir

        echo $count - diff ... $file
	mount -t vfat $dev_path $mount_dir
	$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file
	umount $mount_dir
done
