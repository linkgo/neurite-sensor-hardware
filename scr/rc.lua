print("Hi linkgo.io!")

if file.open('rc_compile.lua') then
	file.close()
	print('Compiling:', 'rc_compile.lua')
	node.compile('rc_compile.lua')
	file.remove('rc_compile.lua')
	collectgarbage()
end
-- comment out this line to save time once files have been compiled
dofile("rc_compile.lc")
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
	dofile("sleep.lc")(3000, 60000)
end
