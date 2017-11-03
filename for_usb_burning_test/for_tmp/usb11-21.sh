#!/bin/sh
host1="host0"
part1="part1"
mount_dir1="/tmp/1-1"
dir1="1"

host2="host1"
part2="part1"
mount_dir2="/tmp/2-1"
dir2="1"

dev_path1="/dev/scsi/$host1/bus0/target0/lun0/$part1"
dev_path2="/dev/scsi/$host2/bus0/target0/lun0/$part2"
file="1812.mp3"
diff_file="/tmp/diff"
count=0;

while [ count ]
	do
        let "count += 1"
        echo $0 $count - copy ... $file

	mount -t vfat $dev_path1 $mount_dir1
	mount -t vfat $dev_path2 $mount_dir2
	rm -f $mount_dir2/$dir2/$file
	cp -f $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2

        echo $0 $count - diff ... $file
	mount -t vfat $dev_path1 $mount_dir1
	mount -t vfat $dev_path2 $mount_dir2
	$diff_file $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2
done
