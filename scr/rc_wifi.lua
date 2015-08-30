-- Begin WiFi configuration

local wifiConfig = {}

-- wifi.STATION         -- station: join a WiFi network
-- wifi.AP              -- access point: create a WiFi network
-- wifi.wifi.STATIONAP  -- both station and access point
wifiConfig.mode = wifi.STATIONAP  -- both station and access point

wifiConfig.accessPointConfig = {}
wifiConfig.accessPointConfig.ssid = "ESP-"..node.chipid()
wifiConfig.accessPointConfig.pwd = "ESP-"..node.chipid()

wifiConfig.stationPointConfig = {}
wifiConfig.stationPointConfig.ssid = "linkgo"
wifiConfig.stationPointConfig.pwd =  "startrock"

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
	local sta_ip = wifi.sta.getip()
	local ap_ip = wifi.ap.getip()
	if sta_ip == nil and retry < 5 then
		print('Connecting to AP...')
		retry = retry + 1
	else
		print('STA IP: ', sta_ip)
		print('AP IP: ', ap_ip)
		dofile('httpserver.lc')(80)
		collectgarbage()
		tmr.stop(tmr_wifi)
	end
end)
