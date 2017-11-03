#!/bin/sh
count=0;

cd /sys/bus/usb/devices/usb1/
echo b805c400 > ./regs_addr
echo 18000000 > ./regs_value
echo b805c410 > ./regs_addr
echo 19000000 > ./regs_value
echo b805c420 > ./regs_addr
echo 1f > ./regs_value
echo b805c430 > ./regs_addr
echo 1f > ./regs_value
echo b805c440 > ./regs_addr
echo 18000000 > ./regs_value
echo b805c450 > ./regs_addr
echo 19000000 > ./regs_value
echo b805c460 > ./regs_addr
echo 1f > ./regs_value
echo b805c470 > ./regs_addr
echo 1f > ./regs_value

umount $mount_dir
while [ count ]
	do
	let "count += 1"
	echo $1 $count - read ...
	
	echo 0xb805c434 > /sys/bus/usb/devices/usb1/regs_addr
	cat /sys/bus/usb/devices/usb1/regs_value
	echo 0xb805c438 > /sys/bus/usb/devices/usb1/regs_addr
	cat /sys/bus/usb/devices/usb1/regs_value
	echo 0xb805c474 > /sys/bus/usb/devices/usb1/regs_addr
	cat /sys/bus/usb/devices/usb1/regs_value
	echo 0xb805c478 > /sys/bus/usb/devices/usb1/regs_addr
	cat /sys/bus/usb/devices/usb1/regs_value
	sleep 2
done

