print("test bme280...")
dofile('rc_i2c.lc')
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

writeRegister(0x76, 0xf2, 0x03)
writeRegister(0x76, 0xf4, 0x3f)

-- temperature
local adc_T = bit.bor(bit.lshift(readRegister(0x76, 0xfa), 12), bit.lshift(readRegister(0x76, 0xfb), 4), bit.rshift(readRegister(0x76, 0xfc), 4))
local dig_T1 = bit.bor(readRegister(0x76, 0x88), bit.lshift(readRegister(0x76, 0x89), 8))
local dig_T2 = bit.bor(readRegister(0x76, 0x8a), bit.lshift(readRegister(0x76, 0x8b), 8))
local dig_T3 = bit.bor(readRegister(0x76, 0x8c), bit.lshift(readRegister(0x76, 0x8d), 8))
local var1 = bit.rshift(((bit.rshift(adc_T, 3) - bit.lshift(dig_T1, 1)) * dig_T2), 11)
local var2 = bit.rshift((bit.rshift(((bit.rshift(adc_T, 4) - dig_T1) * (bit.rshift(adc_T, 4) - dig_T1)), 12) * dig_T3), 14)
t_fine = var1 + var2
bme280_T = bit.rshift((t_fine * 5 + 128), 8) / 100
print("T: "..bme280_T)

-- humidity
local adc_H = bit.bor(bit.lshift(readRegister(0x76, 0xfd), 8), readRegister(0x76, 0xfe))
local dig_H1 = readRegister(0x76, 0xa1)
local dig_H2 = bit.bor(readRegister(0x76, 0xe1), bit.lshift(readRegister(0x76, 0xe2), 8))
local dig_H3 = readRegister(0x76, 0xe3)
local dig_H4 = bit.bor(bit.lshift(readRegister(0x76, 0xe4), 4), bit.band(readRegister(0x76, 0xe5), 0x0f))
local dig_H5 = bit.bor(bit.rshift(readRegister(0x76, 0xe5), 4), bit.lshift(readRegister(0x76, 0xe6), 4))
local dig_H6 = readRegister(0x76, 0xe7)
local v_x1_u32r = t_fine - 76800
v_x1_u32r = bit.rshift(bit.lshift(adc_H, 14) - bit.lshift(dig_H4, 20) - dig_H5 * v_x1_u32r + 16384, 15) * bit.rshift(bit.rshift(v_x1_u32r * bit.rshift(dig_H6, 10) * (bit.rshift(v_x1_u32r * dig_H3, 11) + 32768), 10) + 2097152 * dig_H2 + 8192, 14)
v_x1_u32r = v_x1_u32r - bit.rshift(bit.rshift(bit.rshift(v_x1_u32r, 15) * bit.rshift(v_x1_u32r, 15), 7) * dig_H1, 4)
if v_x1_u32r < 0 then v_x1_u32r = 0 end
if v_x1_u32r > 419430400 then v_x1_u32r = 419430400 end
bme280_H = bit.rshift(v_x1_u32r, 12) / 1024.0
print("H: "..bme280_H)

-- pressure

writeRegister(0x76, 0xf2, 0x00)
writeRegister(0x76, 0xf4, 0x00)

collectgarbage("collect")

print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))
