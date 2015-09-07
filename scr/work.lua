-- start breathing led
local led_duty = 1023
local led_state = 0
tmr.alarm(tmr_led, 50, 1, function()
	if led_duty > 1010 then
		led_state = 1
	elseif led_duty < 512 then
		led_state = 0
	else
	end
	if led_state == 0 then
		led_duty = led_duty + 10
	else
		led_duty = led_duty - 10
	end
	led(led_duty)
end)

print("wifi ready, start rock")
dofile('telnet.lc')

dofile("rc_i2c.lc")
collectgarbage()
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

dofile('mqtt_job.lc')
--print("get lux: "..getlux())
print("job done")

-- dofile("sleep.lc")(3000, 60000)
