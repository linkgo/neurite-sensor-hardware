flag_telnet = false
flag_sensor = false
flag_jobdone = false

dofile("rc_timer.lc")
dofile("rc_gpio.lc")

collectgarbage()

local r = 0
print("check button in 0.5s, debug?")
led(512)
tmr.delay(500000)
led(1023)
r = gpio.read(io_but)

if flag_dsleep == false then
	if r == 0 then
		print("button presssed, delete config")
		file.remove('config.lua')
		file.remove('config.lc')
	end
	collectgarbage()
	dofile("rc_wifi.lc")
	tmr.alarm(tmr_work, 100, 1, function()
		if flag_wifi == true and flag_sensor == true then
			tmr.stop(tmr_work)
			dofile('breath.lc')
			dofile('telnet.lc')
			dofile('mqtt_job.lc')
			dofile('finish_job.lc')
		end
	end)
	dofile("rc_i2c.lc")
	dofile('sensor_power.lc')
	dofile('sensor_light.lc')
	dofile('sensor_bme.lc')
	flag_sensor = true
else
	if r == 1 then
		dofile("sleep.lc")(1000, 3600000)
	else
		print("button presssed, debug mode")
		dofile('but.lc')
	end
end
