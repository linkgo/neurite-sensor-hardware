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

function getlux()
	local tsl2561 = require("tsl2561")
	tsl2561.init(i2c_sda, i2c_scl)

	local l = tsl2561.readVisibleLux()
	print("lux: "..l.." lx")

	tsl2561 = nil
	package.loaded["tsl2561"]=nil
	collectgarbage()
	return l
end

print("wifi ready, start rock")
dofile('telnet.lc')
--print("get lux: "..getlux())
print("job done")

-- dofile("sleep.lc")(3000, 60000)
