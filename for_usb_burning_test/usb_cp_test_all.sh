#!/bin/sh
host1="host0"
part1="part1"
mount_dir1="/mnt/hda"
dir1="1"

host2="host1"
part2="part1"
mount_dir2="/mnt/hdb"
dir2="2"

dev_path1="/dev/scsi/$host1/bus0/target0/lun0/$part1"
dev_path2="/dev/scsi/$host2/bus0/target0/lun0/$part2"
file="1812.mp3"
diff_file="/tmp/diff"
limit=20

echo "cp from port1 to port1..."
count=0
while [ "$count" -lt "$limit" ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t vfat $dev_path1 $mount_dir1
	rm -f $mount_dir1/$dir2/$file
	cp -f $mount_dir1/$dir1/$file $mount_dir1/$dir2/$file
	umount $mount_dir1

        echo $count - diff ... $file
	mount -t vfat $dev_path1 $mount_dir1
	$diff_file $mount_dir1/$dir1/$file $mount_dir1/$dir2/$file
	umount $mount_dir1
done

echo "cp from port1 to port2..."
count=0
while [ "$count" -lt "$limit" ]
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

echo "cp from port2 to port1..."
count=0
while [ "$count" -lt "$limit" ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t vfat $dev_path2 $mount_dir1
	mount -t vfat $dev_path1 $mount_dir2
	rm -f $mount_dir2/$dir2/$file
	cp -f $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2

        echo $count - diff ... $file
	mount -t vfat $dev_path2 $mount_dir1
	mount -t vfat $dev_path1 $mount_dir2
	$diff_file $mount_dir1/$dir1/$file $mount_dir2/$dir2/$file
	umount $mount_dir1 $mount_dir2
done

echo "cp from port2 to port2..."
count=0
while [ "$count" -lt "$limit" ]
	do
        let "count += 1"
        echo $count - copy ... $file

	mount -t vfat $dev_path2 $mount_dir1
	rm -f $mount_dir1/$dir2/$file
	cp -f $mount_dir1/$dir1/$file $mount_dir1/$dir2/$file
	umount $mount_dir1

        echo $count - diff ... $file
	mount -t vfat $dev_path2 $mount_dir1
	$diff_file $mount_dir1/$dir1/$file $mount_dir1/$dir2/$file
	umount $mount_dir1
done

