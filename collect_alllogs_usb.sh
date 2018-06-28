#!/bin/sh
if [ $# -eq 0 ] ; then
echo ERR: You must specify a filename!
exit 5
fi
path=$1
pmlog_rootdir=$path/pm_log
if [ $# -eq 1 ] ; then
name="default"
fi
if [ $# -eq 2 ] ; then
name=$2
fi

src_dir_des_dir="
    /var/log:var_log
    /var/spool/:var_spool
    /mnt/lg/cmn_data/pdm:pdm_log
 /var/lib/connman:connman_log
"
src_files_des_dir="
    /mnt/lg/cmn_data/exc_*.txt:exe_log
"
src_file_des_file="
"

#$path/iwpriv.dat wlan0 set Debug=3
touch /var/lib/connman/debug-mode

sleep 90

timestamp=$(date "+%Y.%m.%d-%H.%M.%S")
mac=`cat /sys/class/net/eth0/address | sed -e 's/://g'`
version=`cut -d ' ' -f 3 /etc/starfish-release`

if ifconfig wlan0 | grep "inet addr"
then
    echo "WiFi connection OK"
else
luna-send -a com.palm.sample -n 1 luna://com.webos.notification/createToast '{"sourceId": "com.webos.service.pdm", "iconUrl": "/usr/share/physical-device-manager/usb_connect.png", "message": "log capture start",  "noaction": false}'
ifconfig -a > $1/ifconfig.txt
mkdir $pmlog_rootdir
for value in ${src_dir_des_dir}; do
    src_dir=`echo $value | cut -f1 -d":"`
    des_dir=`echo $value | cut -f2 -d":"`
    if [ ! -d $pmlog_rootdir/$des_dir ]; then
        echo "mkdir $pmlog_rootdir/$des_dir"
        mkdir $pmlog_rootdir/$des_dir
    fi
    if [ -d $src_dir ]; then
        echo "cp -rv $src_dir/* $pmlog_rootdir/$des_dir/"
        cp -rv $src_dir/* $pmlog_rootdir/$des_dir/
    fi
done
for value in ${src_files_des_dir}; do
    src_file=`echo $value | cut -f1 -d":"`
    des_dir=`echo $value | cut -f2 -d":"`
    if [ ! -d $pmlog_rootdir/$des_dir ]; then
        echo "mkdir $pmlog_rootdir/$des_dir"
        mkdir $pmlog_rootdir/$des_dir
    fi
    echo "cp -rv $src_file $pmlog_rootdir/$des_dir"
    cp -rv $src_file $pmlog_rootdir/$des_dir
done
for value in ${src_file_des_file}; do
    src_file=`echo $value | cut -f1 -d":"`
    des_file=`echo $value | cut -f2 -d":"`
    echo "cp -rv $src_file $pmlog_rootdir/$des_file"
    cp -rv $src_file $pmlog_rootdir/$des_file
done

luna-send -n 1 -f luna://com.webos.memorymanager/getUnitList '{"procList": 10 }' > $pmlog_rootdir/$name-$mac-memorymanager.txt
ps -ef > $pmlog_rootdir/$name-$mac-ps.txt
ps -ef | wc -l > $pmlog_rootdir/$name-$mac-ps-wc.txt
lsof > $pmlog_rootdir/$name-$mac-lsof.txt
lsof | wc -l > $pmlog_rootdir/$name-$mac-lsof-wc.txt
free > $pmlog_rootdir/$name-$mac-free.txt
df -h > $pmlog_rootdir/$name-$mac-df.txt
pstree > $pmlog_rootdir/$name-$mac-pstree.txt
pstree | wc -l > $pmlog_rootdir/$name-$mac-pstree-wc.txt
ps -eo user,pid,ppid,rss,size,vsize,pmem,pcpu,time,cmd --sort -rss | head -n 11 > $pmlog_rootdir/$name-$mac-ps-eo-sort-rss.txt
ifconfig > $pmlog_rootdir/$name-$mac-ifconfig.txt
luna-send -f -n 1 palm://com.palm.connectionmanager/getstatus '{"subscribe": true}' > $pmlog_rootdir/$name-$mac-getstatus.txt
luna-send -f -n 1 luna://com.palm.wifi/findnetworks '{"subscribe": true}' > $pmlog_rootdir/$name-$mac-findnetworks.txt
luna-send -f -n 1 luna://com.webos.service.wifi/getwifidiagnostics '{"subscribe": true}' > $pmlog_rootdir/$name-$mac-hostdignostics.txt

cd $path
tar -cvzf $name-$mac-$version-$timestamp.tgz $pmlog_rootdir
rm -rf $pmlog_rootdir
rm $path/ifconfig.txt
sync
if [ -f $1/$name-$mac-$version-$timestamp.tgz ];then
    luna-send -a com.palm.sample -n 1 luna://com.webos.notification/createToast '{"sourceId": "com.webos.service.pdm", "iconUrl": "/usr/share/physical-device-manager/usb_connect.png", "message": "log capture complete",  "noaction": false}'
fi
fi
