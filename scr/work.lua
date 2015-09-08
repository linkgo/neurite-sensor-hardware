-- start breathing led
local led_duty = 1023
local led_state = 0
tmr.alarm(tmr_led, 50, 1, function()
	if led_duty > 1000 then
		led_state = 1
	elseif led_duty < 512 then
		led_state = 0
	else
	end
	if led_state == 0 then
		led_duty = led_duty + 20
	else
		led_duty = led_duty - 20
	end
	led(led_duty)
end)

print("wifi ready, start rock")
flag_telnet = false
flag_jobdone = false
dofile('telnet.lc')
dofile("rc_i2c.lc")
collectgarbage()
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

-- put regular job here
dofile('mqtt_job.lc')

local cnt = 0
tmr.alarm(tmr_com, 1000, 1, function()
	cnt = cnt + 1
	if flag_jobdone == true or cnt >= 30 then
		tmr.stop(tmr_com)
		if flag_jobdone == false then
			print("warining: sleep without job done!")
		end
		if flag_telnet == true then
			print("telnet connected, ignore sleep")
		else
			dofile("sleep.lc")(1000, 10000)
		end
	end
end)
