local dev_addr = 0x50

print("clear eeprom to 0xff")
for i=0,8,1 do
	i2c_write_reg(dev_addr, i, 0xff)
	tmr.delay(5000)
end

for i=0,8,1 do
	local data = string.format("%02x", string.byte(i2c_read_reg(dev_addr, i)))
	print("read addr "..dev_addr.." reg "..i..": "..data)
	tmr.delay(5000)
end

for i=0,8,1 do
	local val = 0xa0 + i
	i2c_write_reg(dev_addr, i, val)
	print("write addr "..dev_addr.." reg "..i..": "..val)
	tmr.delay(5000)
end

for i=0,8,1 do
	local data = string.format("%02x", string.byte(i2c_read_reg(dev_addr, i)))
	print("read addr "..dev_addr.." reg "..i..": "..data)
	tmr.delay(5000)
end
