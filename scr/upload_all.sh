#!/bin/bash

port=$1

if [ exist$port = 'exist' ]; then
	echo "port invalid, exit."
	exit -1
fi

./upload.sh $port rc.lua
./upload.sh $port rc_wifi.lua
./upload.sh $port rc_gpio.lua
./upload.sh $port rc_i2c.lua
./upload.sh $port rc_spi.lua

./upload.sh $port bq.lua
./upload.sh $port but.lua
./upload.sh $port cat.lua
./upload.sh $port eeprom.lua
./upload.sh $port ls.lua
./upload.sh $port lsap.lua
./upload.sh $port tsl2561.lua
./upload.sh $port tsl.lua
./upload.sh $port bme.lua
./upload.sh $port test.lua
