print("Hi linkgo.io!")

dofile("rc_compile.lua")
dofile("rc_timer.lc")
dofile("rc_gpio.lc")
dofile("rc_i2c.lc")
dofile("tsl2561.lc")
--dofile("but.lc")
if flag_dsleep == false then
	dofile("rc_wifi.lc")
	dofile("work.lc")
else
	dofile("sleep.lc")
end
