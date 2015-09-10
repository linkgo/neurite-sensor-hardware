print("sensor job: bme")

local dig_1 = 0
local dig_2 = 0
local dig_3 = 0
local dig_4 = 0
local dig_5 = 0
local dig_6 = 0
local dig_7 = 0
local dig_8 = 0
local dig_9 = 0
local var1 = 0
local var2 = 0

writeRegister(0x76, 0xf2, 0x03)
writeRegister(0x76, 0xf4, 0x3f)

-- temperature
local adc_T = bit.bor(bit.lshift(readRegister(0x76, 0xfa), 12), bit.lshift(readRegister(0x76, 0xfb), 4), bit.rshift(readRegister(0x76, 0xfc), 4))
local dig_1 = bit.bor(readRegister(0x76, 0x88), bit.lshift(readRegister(0x76, 0x89), 8))
local dig_2 = bit.bor(readRegister(0x76, 0x8a), bit.lshift(readRegister(0x76, 0x8b), 8))
local dig_3 = bit.bor(readRegister(0x76, 0x8c), bit.lshift(readRegister(0x76, 0x8d), 8))
var1 = bit.rshift(((bit.rshift(adc_T, 3) - bit.lshift(dig_1, 1)) * dig_2), 11)
var2 = bit.rshift((bit.rshift(((bit.rshift(adc_T, 4) - dig_1) * (bit.rshift(adc_T, 4) - dig_1)), 12) * dig_3), 14)
local t_fine = var1 + var2
bme280_T = bit.rshift((t_fine * 5 + 128), 8) / 100

-- pressure
local dig_1 = bit.bor(readRegister(0x76, 0x8e), bit.lshift(readRegister(0x76, 0x8f), 8))
local dig_2 = bit.bor(readRegister(0x76, 0x90), bit.lshift(readRegister(0x76, 0x91), 8))
local dig_3 = bit.bor(readRegister(0x76, 0x92), bit.lshift(readRegister(0x76, 0x93), 8))
local dig_4 = bit.bor(readRegister(0x76, 0x94), bit.lshift(readRegister(0x76, 0x95), 8))
local dig_5 = bit.bor(readRegister(0x76, 0x96), bit.lshift(readRegister(0x76, 0x97), 8))
local dig_6 = bit.bor(readRegister(0x76, 0x98), bit.lshift(readRegister(0x76, 0x99), 8))
local dig_7 = bit.bor(readRegister(0x76, 0x9a), bit.lshift(readRegister(0x76, 0x9b), 8))
local dig_8 = bit.bor(readRegister(0x76, 0x9c), bit.lshift(readRegister(0x76, 0x9d), 8))
local dig_9 = bit.bor(readRegister(0x76, 0x9e), bit.lshift(readRegister(0x76, 0x9f), 8))
local adc_P = bit.bor(bit.lshift(readRegister(0x76, 0xf7), 12), bit.lshift(readRegister(0x76, 0xf8), 4), bit.rshift(readRegister(0x76, 0xf9), 4))
var1 = t_fine - 128000
var2 = var1 * var1 * dig_6
var2 = var2 + bit.lshift(var1 * dig_5, 17)
var2 = var2 + bit.lshift(dig_4, 35)
var1 = bit.rshift(var1 * var1 * dig_3, 8) + bit.lshift(var1 * dig_2, 12)
var1 = (bit.lshift(1, 47) + var1) * bit.rshift(dig_1, 33)
if var1 == 0 then
	bme280_P = 0
else
	local p = 1048576 - adc_P
	p = ((bit.lshift(p, 31) - var2) * 3125) / var1;
	var1 = bit.lshift(dig_9 * bit.rshift(p, 13) * bit.rshift(p, 13), 25);
	var2 = bit.rshift(dig_8 * p, 19)
	p = bit.rshift(p + var1 + var2, 8) + bit.lshift(dig_7, 4)
	bme280_P = p / 256
end

-- humidity
local adc_H = bit.bor(bit.lshift(readRegister(0x76, 0xfd), 8), readRegister(0x76, 0xfe))
local dig_1 = readRegister(0x76, 0xa1)
local dig_2 = bit.bor(readRegister(0x76, 0xe1), bit.lshift(readRegister(0x76, 0xe2), 8))
local dig_3 = readRegister(0x76, 0xe3)
local dig_4 = bit.bor(bit.lshift(readRegister(0x76, 0xe4), 4), bit.band(readRegister(0x76, 0xe5), 0x0f))
local dig_5 = bit.bor(bit.rshift(readRegister(0x76, 0xe5), 4), bit.lshift(readRegister(0x76, 0xe6), 4))
local dig_6 = readRegister(0x76, 0xe7)
local v_x1_u32r = t_fine - 76800
v_x1_u32r = bit.rshift(bit.lshift(adc_H, 14) - bit.lshift(dig_4, 20) - dig_5 * v_x1_u32r + 16384, 15) * bit.rshift(bit.rshift(v_x1_u32r * bit.rshift(dig_6, 10) * (bit.rshift(v_x1_u32r * dig_3, 11) + 32768), 10) + 2097152 * dig_2 + 8192, 14)
v_x1_u32r = v_x1_u32r - bit.rshift(bit.rshift(bit.rshift(v_x1_u32r, 15) * bit.rshift(v_x1_u32r, 15), 7) * dig_1, 4)
if v_x1_u32r < 0 then v_x1_u32r = 0 end
if v_x1_u32r > 419430400 then v_x1_u32r = 419430400 end
bme280_H = bit.rshift(v_x1_u32r, 12) / 1024.0

writeRegister(0x76, 0xf2, 0x00)
writeRegister(0x76, 0xf4, 0x00)

file.remove("bme.mqtt")
file.open("bme.mqtt", "w")
file.write(bme280_T.." "..bme280_P.." "..bme280_H)
file.flush()
file.close()

print("T P H: "..bme280_T.." "..bme280_P.." "..bme280_H)
