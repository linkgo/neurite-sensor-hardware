print("# config gpio")

io_ledb = 7
pwm.setup(io_ledb, 100, 512)
pwm.start(io_ledb)
function led(duty)
	pwm.setduty(io_ledb, duty)
end

io_but = 3
gpio.mode(io_but, gpio.INPUT)

print("io_ledb: "..io_ledb)
print("io_but: "..io_but)

-- check button status
flag_dsleep = false

local r = 0
print("check button in 0.5s, sleep/active?")
led(512)
tmr.delay(500000)
led(1023)
r = gpio.read(io_but)

if file.open("config_boot.lc") then
	file.close("config_boot.lc")
	dofile("config_boot.lc")
end

file.remove("config_boot.lua")
file.remove("config_boot.lc")
file.open("config_boot.lua", "w")
if r == 1 then
	print("no button press, dsleep: "..tostring(flag_dsleep))
else
	flag_dsleep = not flag_dsleep
	print("button presssed, dsleep: "..tostring(flag_dsleep))
end
file.writeline('flag_dsleep = '..tostring(flag_dsleep))
file.close()
node.compile("config_boot.lua")
