print("Hi linkgo.io!")

dofile("rc_wifi.lua")
dofile("rc_gpio.lua")
dofile("rc_i2c.lua")
--dofile("rc_spi.lua")
print("prepare late start...")
tmr.alarm(0, 3000, 0, function() dofile("rc_late.lua") end)
