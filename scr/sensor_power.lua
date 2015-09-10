print("sensor job: power")
--local RS = 20
local ac = (256 * readRegister(0x55, 0x15) + readRegister(0x55, 0x14)) * 3.57 / 20
local volt = 256 * readRegister(0x55, 0x09) + readRegister(0x55, 0x08)
local temp = 0.25 * (256 * readRegister(0x55, 0x07) + readRegister(0x55, 0x06)) - 273.15
local sae = (256 * readRegister(0x55, 0x23) + readRegister(0x55, 0x22)) * 29.2 / 20
local tte = 256 * readRegister(0x55, 0x17) + readRegister(0x55, 0x16)
file.remove("power.mqtt")
file.open("power.mqtt", "w")
file.write(ac.." "..volt.." "..temp.." "..sae.." "..tte)
file.flush()
file.close()
--print("average current in 5.12 sec: "..ac.." mA")
--print("battery voltage in 2.56 sec: "..volt.." mV")
--print("temperature in 2.56 sec: "..temp.." C")
--print("available entergy: "..sae.." mWh")
--print("time to empty: "..tte.." minutes")
print(ac.." "..volt.." "..temp.." "..sae.." "..tte)
