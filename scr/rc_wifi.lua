print("# config wifi")
print("<free/used>: "..node.heap().."/"..collectgarbage('count'))

flag_wifi = false

if file.open("config.lc") then
	file.close()
	print("config exists")
	dofile("cat.lc")("config.lua")
	collectgarbage()
	dofile("config.lc")
	wifi.setmode(wifi.STATION)
	wifi.sta.config(ssid, password)
	wifi.sta.connect()

	local ledon = false
	tmr.alarm(tmr_wifi, 50, 1, function()
		if wifi.sta.getip() == nil then
			ledon = not ledon
			if ledon == false then
				led(1023)
			else
				led(512)
			end
		else
			tmr.stop(tmr_wifi)
			print(ssid.." Connected, IP: "..wifi.sta.getip())
			flag_wifi = true
		end
	end)
	tmr.alarm(tmr_com, 20000, 0, function()
		if flag_wifi == false then
			tmr.stop(tmr_wifi)
			print("fail to connect, try at next wake up")
			dofile("sleep.lc")(1000, 300000)
		end
	end)
else
	print("no config, start softap")
	collectgarbage()
	dofile("run_config.lc")
end
