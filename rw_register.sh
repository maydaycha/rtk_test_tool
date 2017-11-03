echo "0x1234abcd 0x0" > /sys/crt/register

if [ $# = 1 ]; then
	echo "0x$1 " > /sys/crt/register; cat /sys/crt/register
fi

if [ $# = 2 ]; then
	echo "0x$1 0x$2" > /sys/crt/register
fi

echo "0xabcd1234 0x0" > /sys/crt/register

exit 0

