function bq_read()
	local RS = 20

	local AIL = readRegister(0x55, 0x14)
	local AIH = readRegister(0x55, 0x15)
	local ac = (256 * AIH + AIL) * 3.57 / RS

	local VOLTL = readRegister(0x55, 0x08)
	local VOLTH = readRegister(0x55, 0x09)
	local volt = 256 * VOLTH + VOLTL

	local TEMPL = readRegister(0x55, 0x06)
	local TEMPH = readRegister(0x55, 0x07)
	local temp = 0.25 * (256 * TEMPH + TEMPL) - 273.15

	local SAEL = readRegister(0x55, 0x22)
	local SAEH = readRegister(0x55, 0x23)
	local sae = (256 * SAEH + SAEL) * 29.2 / RS

	local tte = 256 * readRegister(0x55, 0x17) + readRegister(0x55, 0x16)

	print("average current in 5.12 sec: "..ac.." mA")
	print("battery voltage in 2.56 sec: "..volt.." mV")
	print("temperature in 2.56 sec: "..temp.." C")
	print("available entergy: "..sae.." mWh")
	print("time to empty: "..tte.." minutes")

	return ac, volt, temp, sae, tte
end
