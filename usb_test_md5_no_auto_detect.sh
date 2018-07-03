
usage() {
    echo "Usage: usb_test_md5_no_auto_detect.sh <path1> <path2> [times]"
}


if [ "$1" == "-h" ]; then
    usage
    exit
fi


if [ "$1" == "" ] || [ "$2" == "" ]; then
    usage
    exit
fi


# declare variable
TOPIC="USB TEST MD5 Checksum"
path1=$1
path2=$2
TIMES=$3


copy_file_and_check() {

    # test awk command
    if type awk > /dev/null 2>&1; then
        awk_cmd="awk"
    elif type busybox > /dev/null 2>&1; then
        awk_cmd="busybox awk"
    elif type /bin/busybox > /dev/null 2>&1; then
        awk_cmd="/bin/busybox awk"
    else
        echo >&2 "No avaiable 'awk' command"
        exit
    fi

    # test diff command
    if type diff > /dev/null 2>&1; then
        diff_cmd="diff"
    elif type busybox > /dev/null 2>&1; then
        diff_cmd="busybox diff"
    elif type /bin/busybox > /dev/null 2>&1; then
        diff_cmd="/bin/busybox diff"
    else
        echo >&2 "No avaiable 'diff' command"
        exit
    fi

    copy_from_file=$1
    md5_copy_from_file="$copy_from_file".md5
    copy_to_file=$2
    md5_copy_to_file="$copy_to_file".md5

    # Cleanup md5_source file, md5_destination file and destination file
    rm $md5_copy_from_file $copy_to_file $md5_copy_to_file

    # make md5 for soruce file
    md5sum $copy_from_file | ($awk_cmd 'BEGIN {FS=" "}; {print $1}') > $md5_copy_from_file

    # copy source file to destination
    cp $copy_from_file $copy_to_file

    # make md5 for destination file
    #md5sum $copy_to_file | awk 'BEGIN {FS=" "}; {print $1}' > $md5_copy_to_file || $(echo "md5sum" $copy_to_file "fail..."; exit;)
    md5sum $copy_to_file | ($awk_cmd 'BEGIN {FS=" "}; {print $1}') > $md5_copy_to_file

    # Diff checksume of source file and destination file
    DIFF=$($diff_cmd $md5_copy_from_file $md5_copy_to_file)

    # if succeuss, return 0, else -1
    if [ "$DIFF" == "" ]; then
        echo 0
    else
        echo -1
    fi
}


main() {
    testing_times=$1
    success=0
    fail=0
    i=0
    count=$(((32*1024)))


    mnt_point1=$path1
    mnt_point2=$path2


    # clean usb_md5_test_file
    rm "$mnt_point1/usb_md5_test_file" "$mnt_point2/usb_md5_test_file"

    ## use dd to generate file to mnt_point1
    echo "Generate " $(((16*1024*$count))) " size file"
    dd if=/dev/urandom of="$mnt_point1/usb_md5_test_file" bs=16k count=$count

    copy_from_file="$mnt_point1/usb_md5_test_file"
    copy_to_file="$mnt_point2/usb_md5_test_file"

    echo "test times: " $testing_times

    while [ "$i" != "$testing_times" ] || [ "$testing_times" == "" ]
    do
        echo "Round: "$i

        # flush file system buffer and clear PageCache
        sync; echo 1 > /proc/sys/vm/drop_caches

        nu=$(($i%2))

        if [ "$nu" == "0" ]; then
            echo "copy from "$copy_from_file "to "$copy_to_file
            retval=$(copy_file_and_check $copy_from_file $copy_to_file)
        else
            echo "copy from "$copy_to_file "to "$copy_from_file
            retval=$(copy_file_and_check $copy_to_file $copy_from_file)
        fi

        if [ "$retval" == "0" ]; then
            echo "pass"
            success=$(($success+1))
        else
            echo "fail"
            fail=$(($fail+1))
        fi

        i=$(($i+1))
    done

    #get vendor and model name
    # vid_1=$(cat /sys/bus/usb/devices/1-1/idVendor)
    # pid_1=$(cat /sys/bus/usb/devices/1-1/idProduct)
    # vid_2=$(cat /sys/bus/usb/devices/2-2/idVendor)
    # pid_2=$(cat /sys/bus/usb/devices/2-2/idProduct)

    # result_file=$vid_1"_"$pid_1"-"$vid_2"_"$pid_2"-result.txt"
    result_file=$(date).log

    # Sumeraize the test result. Both output to file and console
    echo "Total Times: "$TIMES "  Pass: "$success "  Fail: "$fail "  Pass rate:" $success"/"$TIMES | tee $result_file

    echo "Finish. result save to " $result_file
}


#main $FROM_FILE $TO_FILE $TIMES $RESULT_FILE

main $3
