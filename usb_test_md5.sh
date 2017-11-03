#check args
if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
	echo "Usage: usb_test_md2.sh [copy_from_file] [copy_to_file] [times] [result_file]"
	echo "File path please use absolute path"
	exit
fi

# declare variable
TOPIC="USB TEST MD5 Checksum"
FROM_FILE=$1
TO_FILE=$2
TIMES=$3
RESULT_FILE=$4
DIFFTIME=0

i=0


main() {
	copy_from_file=$1
	md5_copy_from_file="$copy_from_file".md5
	copy_to_file=$2
	md5_copy_to_file="$copy_to_file".md5
	testing_times=$3
	result_file=$4

	#md5sum $copy_from_file | awk 'BEGIN {FS=" "}; {print $1}' > $md5_copy_from_file || echo "md5sum" $copy_from_file "fail..." && exit
	md5sum $copy_from_file | awk 'BEGIN {FS=" "}; {print $1}' > $md5_copy_from_file

	success=0
	fail=0
	i=0
	while [ "$i" != "$testing_times" ]
	do
		echo "Round: "$i
		rm -f $copy_to_file $md5_copy_to_file

		# flush file system buffer and clear PageCache
		sync; echo 1 > /proc/sys/vm/drop_caches

		#cp $copy_from_file $copy_to_file || $(echo "cp" $copy_from_file $copy_to_file "fail. exit..."; exit;)
		cp $copy_from_file $copy_to_file

		# do md5 checksum for copy_to_file
		#md5sum $copy_to_file | awk 'BEGIN {FS=" "}; {print $1}' > $md5_copy_to_file || $(echo "md5sum" $copy_to_file "fail..."; exit;)
		md5sum $copy_to_file | awk 'BEGIN {FS=" "}; {print $1}' > $md5_copy_to_file

		DIFF=$(diff $md5_copy_from_file $md5_copy_to_file)

		if [ "$DIFF" == "" ]; then
			success=$(($success+1))
		else
			fail=$(($fail+1))
		fi
		i=$(($i+1))
	done

	rm -f $md5_copy_to_file $md5_copy_from_file

	# Sumeraize the test result. Both output to file and console
	echo "Total Times: "$TIMES "  Pass: "$success "  Fail: "$fail "  Pass rate:" $success"/"$TIMES | tee $result_file

	echo "Finish"
}


main $FROM_FILE $TO_FILE $TIMES $RESULT_FILE
