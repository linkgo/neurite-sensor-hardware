print("test tsl2561...")
print("addr 0x29 reg 0x0a: "..string.format("%02x", string.byte(i2c_read_reg(0x29, 0x8a))))
