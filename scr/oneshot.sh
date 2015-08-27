#!/bin/bash

#
# This is the script for one shot scripts uploading
#

port=$1

if [ n$port = 'n' ]; then
	echo "usage:" $0 "PORT"
	exit -1
fi

luatool.py -b 9600 -p $port -f init.lua -t init.lua --verbose -r
sleep 2
./upload_all.sh $port
