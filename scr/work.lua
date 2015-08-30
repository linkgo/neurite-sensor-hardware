-- start breathing led
pwm.setup(io_ledb, 100, 512)
pwm.start(io_ledb)
function led(duty)
	pwm.setduty(io_ledb, duty)
end
local led_duty = 1023
local led_state = 0
tmr.alarm(tmr_led, 10, 1, function()
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

if flag_dsleep == true then
	print("enter dsleep in 3 sec, wake up after 60 sec")
	tmr.alarm(tmr_pwr, 3000, 0, function()
		print("finalize perifs")
		tmr.stop(tmr_led)
		print("dsleep")
		node.dsleep(60000000)
	end)
end
