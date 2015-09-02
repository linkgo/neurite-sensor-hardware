print("test bq27210...")

local RS = 20

local AIL = i2c_read_reg(0x55, 0x14)
local AIH = i2c_read_reg(0x55, 0x15)
local ac = (256 * AIH + AIL) * 3.57 / RS

local VOLTL = i2c_read_reg(0x55, 0x08)
local VOLTH = i2c_read_reg(0x55, 0x09)
local volt = 256 * VOLTH + VOLTL

local TEMPL = i2c_read_reg(0x55, 0x06)
local TEMPH = i2c_read_reg(0x55, 0x07)
local temp = 0.25 * (256 * TEMPH + TEMPL) - 273.15

local SAEL = i2c_read_reg(0x55, 0x22)
local SAEH = i2c_read_reg(0x55, 0x23)
local sae = (256 * SAEH + SAEL) * 29.2 / RS

local tte = 256 * i2c_read_reg(0x55, 0x17) + i2c_read_reg(0x55, 0x16)

print("average current in 5.12 sec: "..ac.." mA")
print("battery voltage in 2.56 sec: "..volt.." mV")
print("temperature in 2.56 sec: "..temp.." C")
print("available entergy: "..sae.." mWh")
print("time to empty: "..tte.." minutes")

collectgarbage()
