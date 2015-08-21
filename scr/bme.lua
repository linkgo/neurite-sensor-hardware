print("test bme280...")
local reg = 0xd0
local len = spi.send(spi_id, reg)
print(len.." byte(s) sent")
local data = spi.recv(spi_id, 1)
print("reg "..reg..": "..string.format("%02x", string.byte(data)))
