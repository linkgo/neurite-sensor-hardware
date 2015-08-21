!/bin/bash

./upload.sh init.lua
./upload.sh rc.lua
./upload.sh rc_gpio.lua
./upload.sh rc_i2c.lua
./upload.sh rc_spi.lua

./upload.sh bq.lua
./upload.sh cat.lua
./upload.sh eeprom.lua
./upload.sh ls.lua
./upload.sh lsap.lua
./upload.sh tsl.lua
./upload.sh bme.lua
./upload.sh test.lua
