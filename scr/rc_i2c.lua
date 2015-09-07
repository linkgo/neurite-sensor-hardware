print("# config i2c")

i2c_id = 0
i2c_sda = gpiomap[12]
i2c_scl = gpiomap[14]

print("i2c_id: "..i2c_id.." i2c_sda: "..i2c_sda.." i2c_scl: "..i2c_scl)

i2c.setup(i2c_id, i2c_sda, i2c_scl, i2c.SLOW)

-- Wrapping I2C functions to retain original calls
Wire = {}
function Wire.beginTransmission(ADDR)
    i2c.start(i2c_id)
    i2c.address(i2c_id, ADDR, i2c.TRANSMITTER)
end

function Wire.write(commands)
    i2c.write(i2c_id, commands)
end

function Wire.endTransmission()
    i2c.stop(i2c_id)
end

function Wire.requestFrom(ADDR, length)
    i2c.start(i2c_id)
    i2c.address(i2c_id, ADDR,i2c.RECEIVER)
    c = i2c.read(i2c_id, length)
    i2c.stop(i2c_id)
    return string.byte(c)
end

function readRegister(deviceAddress, address)
     Wire.beginTransmission(deviceAddress)
     Wire.write(address)                -- register to read
     Wire.endTransmission()
     value = Wire.requestFrom(deviceAddress, 1) -- read a byte
     return value
end

function writeRegister(deviceAddress, address, val)
     Wire.beginTransmission(deviceAddress)  -- start transmission to device
     Wire.write(address)                    -- send register address
     Wire.write(val)                        -- send value to write
     Wire.endTransmission()                 -- end transmission
end
