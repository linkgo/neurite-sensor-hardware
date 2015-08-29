print("checking button...")
local r1 = gpio.read(io_but)
tmr.delay(250000)
local r2 = gpio.read(io_but)
tmr.delay(250000)
local r3 = gpio.read(io_but)

flag_dsleep = 0

if r1 == 1 and r2 == 1 and r3 == 1 then
	print("no button press, enter deep sleep after work")
	flag_dsleep = 1
else
	print("button presssed, enter active")
end
