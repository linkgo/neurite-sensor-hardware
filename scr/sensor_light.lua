print("sensor job: light")
writeRegister(0x29, 0x80, 0x03)
writeRegister(0x29, 0x81, 0x00)
writeRegister(0x29, 0x86, 0x00)
writeRegister(0x29, 0x80, 0x00)
writeRegister(0x29, 0x80, 0x03)
tmr.delay(14000)
local ch0 = bit.bor(bit.lshift(readRegister(0x29, 0x8d), 8), readRegister(0x29, 0x8c))
local ch1 = bit.bor(bit.lshift(readRegister(0x29, 0x8f), 8), readRegister(0x29, 0x8e))
writeRegister(0x29, 0x80, 0x00)
if(ch0/ch1 < 2 and ch0 > 4900) then
	ch0 = -1
	ch1 = -1
end
file.remove("light.mqtt")
file.open("light.mqtt", "w")
file.write(ch0.." "..ch1)
file.flush()
file.close()
print("ch0 ch1: "..ch0.." "..ch1)
