print("Hi linkgo.io!")

-- comment out this line to save time once files have been compiled
if file.open("rc_compile.lc") then
	file.close()
	s,err = pcall(function() dofile("rc_compile.lc") end)
else
	s,err = pcall(function() dofile("rc_compile.lua") end)
end
dofile("rc_timer.lc")
dofile("rc_gpio.lc")
dofile("rc_i2c.lc")
dofile("tsl2561.lc")
--dofile("but.lc")
if flag_dsleep == false then
	dofile("rc_wifi.lc")
	tmr.alarm(tmr_work, 100, 1, function()
		if (flag_wifi == true) then
			tmr.stop(tmr_work)
			dofile("work.lc")
		end
	end)
else
	local t = wifi.sleeptype(wifi.LIGHT_SLEEP)
	print("sleep type: "..t)
	dofile("sleep.lc")(30000, 60000)
end
