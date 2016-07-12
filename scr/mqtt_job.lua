print("start mqtt job")
print("<free/used>: "..node.heap().."/"..collectgarbage('count'))

MQTT_ID = "esp-"..node.chipid()
puback_sum = 0
PUBACK_MAX = 4

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

function do_mqttpub(topic, msg)
	m:publish(topic, msg, 0, 0, function(conn)
		puback_sum = putack_sum + 1
		print("["..string.format("%8.3f", tmr.now()/1000000).."] published "..puback_sum)
	end)
end

m:connect("123.57.208.39", 1883, 0, function(conn)
	print("connected")
	flag_mqtt = true
	do_mqttpub("/up/checkin/neuron", MQTT_ID)
	m:subscribe("/down/neuron/"..MQTT_ID.."/#", 0, function(conn)
		print("subscribe success")
	end)
end)

tmr.alarm(tmr_work, 100, 1, function()
	if puback_sum >= PUBACK_MAX then
		flag_jobdone = true
		tmr.stop(tmr_work)
		print("mqtt job done perfectly")
	end
end)
