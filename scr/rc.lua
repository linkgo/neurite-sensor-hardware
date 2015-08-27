print("Hi linkgo.io!")

dofile("rc_wifi.lua")
dofile("rc_gpio.lua")
dofile("rc_i2c.lua")
--dofile("rc_spi.lua")
print("init tsl2561...")
dofile("tsl2561.lua")
print("  [ok]")
