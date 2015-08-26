#!/bin/bash

port=$1
file=$2
baud=$3

if [ ! -f "$file" -o exist$port = 'exist' ]; then
	echo "arguments invalid, exit."
	exit -1
fi

if [ n$baud = 'n' ]; then
	baud=115200
fi

luatool.py -b $baud -p $port -f $file -t $file --verbose
