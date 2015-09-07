tmr.alarm(0, 1000, 1, function()
	tsl2561 = require("tsl2561")
	tsl2561.init()
	local ch0, ch1 = tsl2561.readRaw()
	print("0: "..ch0.." 1: "..ch1)
	tsl2561 = nil
	package.loaded["tsl2561"]=nil
	collectgarbage()
end)
