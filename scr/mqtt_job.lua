print("start mqtt job")

local MQTT_ID         = "esp-"..node.chipid()
local TOPIC_SUB       = "/down/neuron/"..MQTT_ID.."/#"
local TOPIC_CHECKIN   = "/up/checkin/neuron"
local TOPIC_FINISH    = "/up/finish/neuron"
local TOPIC_PUB_LIGHT = "/up/neuron/"..MQTT_ID.."/light"
local TOPIC_PUB_POWER = "/up/neuron/"..MQTT_ID.."/power"

-- It needs to define as many as the number of publishing jobs.
-- Necessary for confirming all the jobs done.
-- Holy bad idea since I don't know how to sync among callbacks.
local putack_sum = 0
local PUTACK_MAX = 3
local putack_result = true
local putack = {
	checkin = false,
	light = false,
	power = false,
}

local sem_mqtt = false

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

-- FIXME Async!!! This function can't be used, or reentrant will be a hard rock.
-- I don't know how to handle this yet.
-- For now, publish cannot be done one by one in order.
local function do_mqttpub(topic, msg)
	m:publish(topic, msg, 0, 0, function(conn)
		print("["..string.format("%8.3f", tmr.now()/1000000).."] > "..topic..": "..msg)
	end)
end

local function mqttpub_light()
	tsl2561 = require("tsl2561")
	tsl2561.init()
	local ch0, ch1 = tsl2561.readRaw()
	tsl2561 = nil
	package.loaded["tsl2561"] = nil
	collectgarbage()
	m:publish(TOPIC_PUB_LIGHT, ch0.." "..ch1, 0, 0, function(conn)
		putack.light = true
		putack_sum = putack_sum + 1
		print("["..string.format("%8.3f", tmr.now()/1000000).."] > "..TOPIC_PUB_LIGHT..": "..MQTT_ID)
	end)
end

local function mqttpub_power()
	local ac, volt, temp, sae, tte = bq_read()
	m:publish(TOPIC_PUB_POWER, ac.." "..volt.." "..temp.." "..sae.." "..tte, 0, 0, function(conn)
		putack.power = true
		putack_sum = putack_sum + 1
		print("["..string.format("%8.3f", tmr.now()/1000000).."] > "..TOPIC_PUB_POWER..": "..ac.." "..volt.." "..temp.." "..sae.." "..tte)
	end)
end

m:connect("123.57.208.39", 1883, 0, function(conn)
	print("connected")

	m:publish(TOPIC_CHECKIN, MQTT_ID, 0, 0, function(conn)
		putack.checkin = true
		putack_sum = putack_sum + 1
		print("["..string.format("%8.3f", tmr.now()/1000000).."] > "..TOPIC_CHECKIN..": "..MQTT_ID)
	end)
	mqttpub_light()
	mqttpub_power()

	m:subscribe(TOPIC_SUB, 0, function(conn)
		print("subscribe success")
	end)
end)

tmr.alarm(tmr_work, 100, 1, function()
	for k, v in pairs(putack) do
		putack_result = putack_result and v
	end
	if putack_result == true or putack_sum >= PUTACK_MAX then
		flag_jobdone = true
		tmr.stop(tmr_work)
		tmr.stop(tmr_com1)
		print("job done perfectly")
	end
end)

--tmr.alarm(tmr_com1, 5000, 1, function()
--	print("job status")
--	for k, v in pairs(putack) do
--		print(k, v)
--	end
--end)
