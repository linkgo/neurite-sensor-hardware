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
