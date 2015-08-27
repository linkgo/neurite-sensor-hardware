print("config gpio...")
gpiomap = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}

led_b = gpiomap[13]

gpio.mode(led_b, gpio.OUTPUT)
gpio.write(led_b, gpio.LOW)
tmr.delay(250000)
gpio.write(led_b, gpio.HIGH)

io_but = gpiomap[0]

gpio.mode(io_but, gpio.INT)
local value = true
local pulse1 = 0
local du = 0
function but_cb(level)
	tmr.delay(10000)
	if gpio.read(io_but) == 1 then
		print("spurious trig")
		return nil
	end
	value = not value
	if value == false then
		gpio.write(led_b, gpio.LOW)
		print("low")
	else
		gpio.write(led_b, gpio.HIGH)
		print("high")
	end
end
gpio.trig(io_but, "down", but_cb)

print("  [ok]")
