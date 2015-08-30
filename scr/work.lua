-- start breathing led
local led_duty = 1023
local led_state = 0
tmr.alarm(4, 10, 1, function()
	if led_duty > 1020 then
		led_state = 1
	elseif led_duty < 512 then
		led_state = 0
	else
	end
	if led_state == 0 then
		led_duty = led_duty + 2
	else
		led_duty = led_duty - 2
	end
	led(led_duty)
end)

print("start normal work")
print("job done")

if flag_dsleep == 1 then
	print("enter dsleep in 3 sec, wake up after 60 sec")
	tmr.stop(4)
	tmr.alarm(5, 3000, 0, function() print("dsleep") node.dsleep(60000000) end)
end
