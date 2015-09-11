print("start mqtt job")
print("<free/used>: "..node.heap().."/"..collectgarbage('count'))

local MQTT_ID = "esp-"..node.chipid()
local putack_sum = 0
local PUTACK_MAX = 4

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
	local buf = nil

	do_mqttpub("/up/checkin/neuron", MQTT_ID)

	if file.open("power.mqtt", "r") then
		buf = file.readline()
		do_mqttpub("/up/neuron/"..MQTT_ID.."/power", buf)
		file.close()
	else
		print("err open power.mqtt")
	end

	if file.open("light.mqtt", "r") then
		buf = file.readline()
		do_mqttpub("/up/neuron/"..MQTT_ID.."/light", buf)
		file.close()
	else
		print("err open light.mqtt")
	end

	if file.open("bme.mqtt", "r") then
		buf = file.readline()
		do_mqttpub("/up/neuron/"..MQTT_ID.."/bme", buf)
		file.close()
	else
		print("err open bme.mqtt")
	end

	m:subscribe("/down/neuron/"..MQTT_ID.."/#", 0, function(conn)
		print("subscribe success")
	end)
end)

tmr.alarm(tmr_work, 100, 1, function()
	if putack_sum >= PUTACK_MAX then
		flag_jobdone = true
		tmr.stop(tmr_work)
		print("mqtt job done perfectly")
	end
end)
