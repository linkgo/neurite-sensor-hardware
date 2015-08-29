print("checking button...")
local r1 = gpio.read(io_but)
tmr.delay(250000)
local r2 = gpio.read(io_but)
tmr.delay(250000)
local r3 = gpio.read(io_but)

if r1 == 1 and r2 == 1 and r3 == 1 then
	print("no button press, enter dsleep")
	node.dsleep(60000000)
else
	print("button presssed, enter active")
end
