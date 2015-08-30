-- Begin WiFi configuration

local wifiConfig = {}

-- wifi.STATION         -- station: join a WiFi network
-- wifi.AP              -- access point: create a WiFi network
-- wifi.wifi.STATIONAP  -- both station and access point
wifiConfig.mode = wifi.STATIONAP  -- both station and access point

wifiConfig.accessPointConfig = {}
wifiConfig.accessPointConfig.ssid = "ESP-"..node.chipid()   -- Name of the SSID you want to create
wifiConfig.accessPointConfig.pwd = "ESP-"..node.chipid()    -- WiFi password - at least 8 characters

wifiConfig.stationPointConfig = {}
wifiConfig.stationPointConfig.ssid = "nubial"               -- Name of the WiFi network you want to join
wifiConfig.stationPointConfig.pwd =  "basicbox565"          -- Password for the WiFi network

-- Tell the chip to connect to the access point

wifi.setmode(wifiConfig.mode)
print('set (mode='..wifi.getmode()..')')
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())

wifi.ap.config(wifiConfig.accessPointConfig)
wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd)
wifiConfig = nil
collectgarbage()

-- End WiFi configuration

-- Connect to the WiFi access point.
-- Once the device is connected, you may start the HTTP server.

local retry = 0

tmr.alarm(tmr_wifi, 3000, 1, function()
	local ip = wifi.sta.getip()
	if ip == nil then
		print('Connecting to WiFi Access Point ...')
		retry = retry + 1
	else
		print('IP: ',ip)
		dofile("httpserver.lc")(80)
		local server_up = true
		collectgarbage()
		tmr.stop(tmr_wifi)
	end
	if retry > 5 then
		dofile("sleep.lua")
	end
end)
