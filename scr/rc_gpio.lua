print("config gpio")
gpiomap = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}

io_ledb = gpiomap[13]
gpio.mode(io_ledb, gpio.OUTPUT)

io_but = gpiomap[0]
gpio.mode(io_but, gpio.INPUT)

print("io_ledb: "..io_ledb)
print("io_but: "..io_but)

-- check button status
local r = {[0] = 0, [1] = 0}
flag_dsleep = 0
print("checking button...")
for i = 0, 1, 1 do
	gpio.write(io_ledb, gpio.LOW)
	tmr.delay(250000)
	gpio.write(io_ledb, gpio.HIGH)
	tmr.delay(250000)
	r[i] = gpio.read(io_but)
end

if r[0] == 1 and r[1] == 1 then
	print("no button press, enter deep sleep after work")
	flag_dsleep = 1
else
	print("button presssed, enter active")
end

-- config pwm for led
pwm.setup(io_ledb, 100, 512)
pwm.start(io_ledb)
function led(duty)
	pwm.setduty(io_ledb, duty)
end
