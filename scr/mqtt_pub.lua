local data = 0

tmr.alarm(tmr_work, 2000, 1, function()
	data = 123
	m:publish("/neuron/"..mqtt_id.."/light/ch0", data, 0, 0, function(conn)
		print("["..string.format("%8.3f", tmr.now()/1000000).."] sent: "..data)
	end)

	data = 456
	m:publish("/neuron/"..mqtt_id.."/light/ch1", data, 0, 0, function(conn)
		print("["..string.format("%8.3f", tmr.now()/1000000).."] sent: "..data)
	end)
end)

tmr.alarm(tmr_com, 10000, 0, function()
	tmr.stop(tmr_work)
end)
