#!/bin/bash

port=$1
file=$2

if [ ! -f "$file" -o exist$port = 'exist' ]; then
	echo "arguments invalid, exit."
	exit -1
fi

luatool.py -b 115200 -p $port -f $file -t $file --verbose
