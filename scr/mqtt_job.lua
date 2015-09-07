mqtt_id = "esp-"..node.chipid()
m = mqtt.Client(mqtt_id, 120, nil, nil)

m:on("connect", function(con)
	print ("connected")
end)
m:on("offline", function(con)
	print ("offline")
end)

m:on("message", function(conn, topic, data)
	print("topic: "..topic)
	if data ~= nil then
		print("data: "..data)
	end
end)

m:connect("123.57.208.39", 1883, 0, function(conn)
	print("connected")
	m:subscribe("/#", 0, function(conn)
		print("subscribe success")
	end)
	dofile('mqtt_pub.lc')
end)
