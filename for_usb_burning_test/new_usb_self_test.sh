#!/bin/sh
dev_path="/dev/sda1"
mount_dir="/tmp/usbmounts"
dir1="1"
dir2="2"

#file="1812-1.mp3"
file="1812.mp3"
diff_file="diff"
count=0;

while [ count ]
do
let "count += 1"
echo $count - copy ... $file

mount $dev_path $mount_dir || exit
rm -f $mount_dir/$dir2/$file
cp -f $mount_dir/$dir1/$file $mount_dir/$dir2/$file
umount $mount_dir

echo $count - diff ... $file
mount $dev_path $mount_dir || exit
$diff_file $mount_dir/$dir1/$file $mount_dir/$dir2/$file || mv $mount_dir/$dir2/$file $mount_dir/$dir2/$file.$count
umount $mount_dir
done

