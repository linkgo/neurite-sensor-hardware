print("# config gpio")
gpiomap = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}

io_ledb = gpiomap[13]
gpio.mode(io_ledb, gpio.OUTPUT)
pwm.setup(io_ledb, 100, 512)
pwm.start(io_ledb)
function led(duty)
	pwm.setduty(io_ledb, duty)
end

io_but = gpiomap[0]
gpio.mode(io_but, gpio.INPUT)

print("io_ledb: "..io_ledb)
print("io_but: "..io_but)

-- check button status
local r = 0
flag_dsleep = false
print("check button in 0.5s")
gpio.write(io_ledb, gpio.LOW)
tmr.delay(500000)
gpio.write(io_ledb, gpio.HIGH)
r = gpio.read(io_but)
if r == 1 then
	print("no button press, sleep soon")
	flag_dsleep = true
else
	print("button presssed, active mode")
end
