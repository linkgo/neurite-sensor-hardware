print("# config i2c")

i2c_id = 0
i2c_sda = gpiomap[12]
i2c_scl = gpiomap[14]

print("i2c_id: "..i2c_id.." i2c_sda: "..i2c_sda.." i2c_scl: "..i2c_scl)

i2c.setup(i2c_id, i2c_sda, i2c_scl, i2c.SLOW)

function i2c_read_reg(dev_addr, reg_addr)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.TRANSMITTER)
	i2c.write(i2c_id, reg_addr)
	i2c.stop(i2c_id)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.RECEIVER)
	local c = i2c.read(i2c_id, 1)
	i2c.stop(i2c_id)
	return string.byte(c)
end

function i2c_write_reg(dev_addr, reg_addr, reg_val)
	i2c.start(i2c_id)
	i2c.address(i2c_id, dev_addr, i2c.TRANSMITTER)
	i2c.write(i2c_id, reg_addr)
	i2c.write(i2c_id, reg_val)
	i2c.stop(i2c_id)
end
