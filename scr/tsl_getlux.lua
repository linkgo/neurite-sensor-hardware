return function()
	tsl2561 = require("tsl2561")
	tsl2561.init(i2c_sda, i2c_scl)

	l = tsl2561.readVisibleLux()
	print("lux: "..l.." lx")

	tsl2561 = nil
	package.loaded["tsl2561"]=nil
	collectgarbage()
end
