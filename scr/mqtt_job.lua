print("start mqtt job")

-- power
--local RS = 20
local ac = (256 * readRegister(0x55, 0x15) + readRegister(0x55, 0x14)) * 3.57 / 20
local volt = 256 * readRegister(0x55, 0x09) + readRegister(0x55, 0x08)
local temp = 0.25 * (256 * readRegister(0x55, 0x07) + readRegister(0x55, 0x06)) - 273.15
local sae = (256 * readRegister(0x55, 0x23) + readRegister(0x55, 0x22)) * 29.2 / 20
local tte = 256 * readRegister(0x55, 0x17) + readRegister(0x55, 0x16)
--print("average current in 5.12 sec: "..ac.." mA")
--print("battery voltage in 2.56 sec: "..volt.." mV")
--print("temperature in 2.56 sec: "..temp.." C")
--print("available entergy: "..sae.." mWh")
--print("time to empty: "..tte.." minutes")

-- light
tsl2561 = require("tsl2561")
tsl2561.init()
local ch0, ch1 = tsl2561.readRaw()
tsl2561 = nil
package.loaded["tsl2561"] = nil
collectgarbage()

print("prepare data finished")

-- mqtt things
local MQTT_ID         = "esp-"..node.chipid()
local TOPIC_SUB       = "/down/neuron/"..MQTT_ID.."/#"
local TOPIC_CHECKIN   = "/up/checkin/neuron"
local TOPIC_FINISH    = "/up/finish/neuron"
local TOPIC_PUB_LIGHT = "/up/neuron/"..MQTT_ID.."/light"
local TOPIC_PUB_POWER = "/up/neuron/"..MQTT_ID.."/power"

local putack_sum = 0
local PUTACK_MAX = 3

m = mqtt.Client(MQTT_ID, 120, nil, nil)

m:on("connect", function(con)
	print ("connected")
end)
m:on("offline", function(con)
	print ("offline")
end)

m:on("message", function(conn, topic, data)
	print("["..string.format("%8.3f", tmr.now()/1000000).."] < topic: "..topic)
	if data ~= nil then
		print("data: "..data)
	end
end)

local function do_mqttpub(topic, msg)
	m:publish(topic, msg, 0, 0, function(conn)
		putack_sum = putack_sum + 1
		print("["..string.format("%8.3f", tmr.now()/1000000).."] published "..putack_sum)
	end)
end

m:connect("123.57.208.39", 1883, 0, function(conn)
	print("connected")

	do_mqttpub(TOPIC_CHECKIN, MQTT_ID)
	collectgarbage()
	do_mqttpub(TOPIC_PUB_POWER, ac.." "..volt.." "..temp.." "..sae.." "..tte)
	collectgarbage()
	do_mqttpub(TOPIC_PUB_LIGHT, ch0.." "..ch1)
	collectgarbage()

	m:subscribe(TOPIC_SUB, 0, function(conn)
		print("subscribe success")
	end)
	collectgarbage()
end)

tmr.alarm(tmr_work, 100, 1, function()
	if putack_sum >= PUTACK_MAX then
		flag_jobdone = true
		tmr.stop(tmr_work)
		print("job done perfectly")
	end
end)
