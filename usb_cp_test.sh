PATH1="/storage/sda1"
PATH2="/storage/sdb1"
FILE_NAME="test_file"
LOG_FILE="/tmp/usb_test.log"

rm $LOG_FILE;

echo "Generate 512MiB file....";
echo "Generate 512MiB file...." >> $LOG_FILE;
dd if=/dev/zero of=$PATH1/$FILE_NAME bs=64k count=8k;
rc=$?
if [[ $rc != 0 ]]; then
    echo "test fail" >> $LOG_FILE;
    exit;
fi

sync;
echo 3 > /proc/sys/vm/drop_caches;

round=0
r=$((r + 1))
while [ 1 == 1 ]
do
    round=$((round + 1));
    echo "------------ Round " $round "--------------" >> $LOG_FILE
    dd if=$PATH1/$FILE_NAME of=$PATH2/$FILE_NAME bs=64k;
    rc=$?
    if [[ $rc != 0 ]]; then
        echo "test fail" >> $LOG_FILE;
        echo "tes fail exit!";
        exit;
    fi
    echo "copy from " $PATH1 " to " $PATH2 "ok ! ";
    echo "copy from " $PATH1 " to " $PATH2 "ok ! " >> $LOG_FILE;

    rm $PATH1/$FILE_NAME;
    sync;
    echo 3 > /proc/sys/vm/drop_caches;


    dd if=$PATH2/$FILE_NAME of=$PATH1/$FILE_NAME bs=64k;
    rc=$?
    if [[ $rc != 0 ]]; then
        echo "test fail" >> $LOG_FILE;
        echo "tes fail exit!";
        exit;
    fi
    echo "copy from " $PATH2 " to " $PATH1 "ok ! ";
    echo "copy from " $PATH2 " to " $PATH1 "ok ! " >> $LOG_FILE;

    rm $PATH2/$FILE_NAME;
    sync;
    echo 3 > /proc/sys/vm/drop_caches;
done







