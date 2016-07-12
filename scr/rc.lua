flag_telnet = false
flag_jobdone = false
flag_mqtt = false

dofile("rc_timer.lc")
dofile("rc_gpio.lc")

collectgarbage()

local r = 0
print("check button in 0.5s, debug?")
led(512)
tmr.delay(500000)
led(1023)
r = gpio.read(io_but)

dofile("rc_i2c.lc")

if flag_dsleep == false then
	collectgarbage()
	dofile("rc_wifi.lc")
	tmr.alarm(tmr_work, 100, 1, function()
		if flag_wifi == true then
			tmr.stop(tmr_work)
			dofile('breath.lc')
			print("start mqtt job")
			print("<free/used>: "..node.heap().."/"..collectgarbage('count'))

			MQTT_ID = "esp-"..node.chipid()
			puback_sum = 0
			PUBACK_MAX = 4

			m = mqtt.Client(MQTT_ID, 120, nil, nil)

			m:on("connect", function(con)
				print ("m:on connected")
			end)
			m:on("offline", function(con)
				print ("m:on offline")
			end)

			m:on("message", function(conn, topic, data)
				print("["..string.format("%8.3f", tmr.now()/1000000).."] < topic: "..topic)
				if data ~= nil then
					print("data: "..data)
				end
			end)

			function do_mqttpub(topic, msg)
				m:publish(topic, msg, 0, 0, function(conn)
					puback_sum = puback_sum + 1
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
		end
	end)
	tmr.alarm(tmr_com1, 1000, 1, function()
		if flag_mqtt == true then
			dofile('sensor_power.lc')
			dofile('sensor_light.lc')
			--dofile('sensor_bme.lc')
			local buf = nil
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
			--[====[
			if file.open("bme.mqtt", "r") then
				buf = file.readline()
				do_mqttpub("/up/neuron/"..MQTT_ID.."/bme", buf)
				file.close()
			else
				print("err open bme.mqtt")
			end
			]====]
		end
	end)
else
	if r == 1 then
		dofile("sleep.lc")(1000, 3600000)
	else
		print("button presssed, debug mode")
		dofile('but.lc')
	end
end
