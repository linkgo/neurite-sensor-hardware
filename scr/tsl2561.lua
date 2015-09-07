print("# config tsl2561")

local TSL2561_Control = 0x80
local TSL2561_Timing = 0x81
local TSL2561_Interrupt = 0x86
local TSL2561_Channel0L = 0x8C
local TSL2561_Channel0H = 0x8D
local TSL2561_Channel1L = 0x8E
local TSL2561_Channel1H = 0x8F

local TSL2561_Address = 0x29   -- device address

local moduleName = 0
local M = {}
_G[moduleName] = M

-- i2c interface ID
local id = 0

-- local vars
local ch0, ch1 = 0

function M.getLux()
    local CH0_LOW=readRegister(TSL2561_Address, TSL2561_Channel0L)
    local CH0_HIGH=readRegister(TSL2561_Address, TSL2561_Channel0H)
    --read two bytes from registers 0x0E and 0x0F
    local CH1_LOW=readRegister(TSL2561_Address, TSL2561_Channel1L)
    local CH1_HIGH=readRegister(TSL2561_Address, TSL2561_Channel1H)

    ch0 = bit.bor(bit.lshift(CH0_HIGH,8), CH0_LOW)
    ch1 = bit.bor(bit.lshift(CH1_HIGH,8), CH1_LOW)
end

function M.init()
   writeRegister(TSL2561_Address, TSL2561_Control, 0x03)  -- POWER UP
   writeRegister(TSL2561_Address, TSL2561_Timing, 0x00)  --No High Gain (1x), integration time of 13ms
   writeRegister(TSL2561_Address, TSL2561_Interrupt, 0x00)
   writeRegister(TSL2561_Address, TSL2561_Control, 0x00)  -- POWER Down
end

function M.readRaw()
   writeRegister(TSL2561_Address, TSL2561_Control, 0x03)  -- POWER UP
   tmr.delay(14000)
   M.getLux()

   writeRegister(TSL2561_Address, TSL2561_Control, 0x00)  -- POWER Down
   if(ch0/ch1 < 2 and ch0 > 4900) then
     return -1, -1
   end
   return ch0, ch1
end

return M
