print("test bq27210...")
print("addr 0x55 reg 0x00: "..string.format("%02x", string.byte(i2c_read_reg(0x55, 0x00))))
