print("config gpio")
gpiomap = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}

led_b = gpiomap[13]
gpio.mode(led_b, gpio.OUTPUT)

io_but = gpiomap[0]
gpio.mode(io_but, gpio.INPUT)

print("led_b: "..led_b)
print("io_but: "..io_but)

-- check button status

local r = {[0] = 0, [1] = 0}

flag_dsleep = 0

print("checking button...")
for i = 0, 1, 1 do
	gpio.write(led_b, gpio.LOW)
	tmr.delay(250000)
	gpio.write(led_b, gpio.HIGH)
	tmr.delay(250000)
	r[i] = gpio.read(io_but)
end

if r[0] == 1 and r[1] == 1 then
	print("no button press, enter deep sleep after work")
	flag_dsleep = 1
else
	print("button presssed, enter active")
end
