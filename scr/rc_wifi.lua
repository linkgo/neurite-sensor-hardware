print("# config wifi")

flag_config = false
flag_wifi = false
local timeout = 5000

print('sta mac: ',wifi.sta.getmac())
print('ap mac: ',wifi.ap.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())

if file.open("config.lc") then
	file.close()
	flag_config = true
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
			print("connecting...")
		else
			tmr.stop(tmr_wifi)
			print(ssid.." Connected, IP: "..wifi.sta.getip())
			flag_wifi = true
		end
	end)
	tmr.alarm(tmr_com, timeout, 0, function()
		if flag_wifi == false then
			tmr.stop(tmr_wifi)
			print("fail to connect, start softap")
			collectgarbage()
			dofile("run_config.lc")
		end
	end)
else
	flag_config = false
	print("no config, start softap")
	collectgarbage()
	dofile("run_config.lc")
end
