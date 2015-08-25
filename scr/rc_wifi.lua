local mode_str = {
	[1]="STATION",
	[2]="SOFTAP",
	[3]="STATIONAP"
}

local mode = wifi.getmode()

mode = wifi.STATION
wifi.setmode(mode)

print("set to mode: "..mode.."("..mode_str[mode]..")")
