local TSL2561_Control = 0x80
local TSL2561_Timing = 0x81
local TSL2561_Interrupt = 0x86
local TSL2561_Channel0L = 0x8C
local TSL2561_Channel0H = 0x8D
local TSL2561_Channel1L = 0x8E
local TSL2561_Channel1H = 0x8F

local TSL2561_Address = 0x29   -- device address

local LUX_SCALE     = 14       -- scale by 2^14
local RATIO_SCALE   = 9        -- scale ratio by 2^9
local CH_SCALE      = 10       -- scale channel values by 2^10
local CHSCALE_TINT0 = 0x7517   -- 322/11 * 2^CH_SCALE
local CHSCALE_TINT1 = 0x0fe7   -- 322/81 * 2^CH_SCALE

local moduleName = 0
local M = {}
_G[moduleName] = M

-- i2c interface ID
local id = 0

-- local vars
local ch0,ch1,chScale,channel1,channel0,ratio1,b,m,temp,lux = 0

-- Wrapping I2C functions to retain original calls
local Wire = {}
function Wire.beginTransmission(ADDR)
    i2c.start(id)
    i2c.address(id, ADDR, i2c.TRANSMITTER)
end

function Wire.write(commands)
    i2c.write(id, commands)
end

function Wire.endTransmission()
    i2c.stop(id)
end

function Wire.requestFrom(ADDR, length)
    i2c.start(id)
    i2c.address(id, ADDR,i2c.RECEIVER)
    c = i2c.read(id, length)
    i2c.stop(id)
    return string.byte(c)
end

local function readRegister(deviceAddress, address)
     Wire.beginTransmission(deviceAddress)
     Wire.write(address)                -- register to read
     Wire.endTransmission()
     value = Wire.requestFrom(deviceAddress, 1) -- read a byte
     return value
end

local function writeRegister(deviceAddress, address, val)
     Wire.beginTransmission(deviceAddress)  -- start transmission to device
     Wire.write(address)                    -- send register address
     Wire.write(val)                        -- send value to write
     Wire.endTransmission()                 -- end transmission
end

function M.getLux()
    local CH0_LOW=readRegister(TSL2561_Address,TSL2561_Channel0L)
    local CH0_HIGH=readRegister(TSL2561_Address,TSL2561_Channel0H)
    --read two bytes from registers 0x0E and 0x0F
    local CH1_LOW=readRegister(TSL2561_Address,TSL2561_Channel1L)
    local CH1_HIGH=readRegister(TSL2561_Address,TSL2561_Channel1H)

    ch0 = bit.bor(bit.lshift(CH0_HIGH,8),CH0_LOW)
    ch1 = bit.bor(bit.lshift(CH1_HIGH,8),CH1_LOW)
end

function M.init(sda, scl)
   i2c.setup(id, sda, scl, i2c.SLOW)
   writeRegister(TSL2561_Address,TSL2561_Control,0x03)  -- POWER UP
   writeRegister(TSL2561_Address,TSL2561_Timing,0x00)  --No High Gain (1x), integration time of 13ms
   writeRegister(TSL2561_Address,TSL2561_Interrupt,0x00)
   writeRegister(TSL2561_Address,TSL2561_Control,0x00)  -- POWER Down
end

function M.readVisibleLux()
   writeRegister(TSL2561_Address,TSL2561_Control,0x03)  -- POWER UP
   tmr.delay(14000)
   M.getLux()

   writeRegister(TSL2561_Address,TSL2561_Control,0x00)  -- POWER Down
   if(ch0/ch1 < 2 and ch0 > 4900) then
     return -1  -- ch0 out of range, but ch1 not. the lux is not valid in this situation.
   end
     print("ch0: "..ch0.." ch1: "..ch1)
     return 0
end

return M
