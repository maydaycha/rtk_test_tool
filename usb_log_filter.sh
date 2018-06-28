file=$1

if [ "$file" == "" ]; then
    file=.
fi

grep --color -rnH $file \
    -e usb \
    -e storage \
    -e invoke \
    -e bio \
    -e disconnect \
    -e "using xhci" \
    -e "using ehci" \
    -e "using ohci" \
    -e blk
