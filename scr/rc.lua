print("Hi linkgo.io!")

dofile("rc_compile.lua")
dofile("rc_timer.lua")
dofile("rc_gpio.lua")
dofile("rc_i2c.lua")
dofile("tsl2561.lua")
--dofile("but.lua")
if flag_dsleep == false then
	dofile("rc_wifi.lua")
	dofile("work.lua")
else
	dofile("sleep.lua")
end
