print("Hi linkgo.io!")
print("sta mac:  "..wifi.sta.getmac())
print("ap mac:   "..wifi.ap.getmac())
print("chip:     "..node.chipid())
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

if file.open('rc_compile.lua') then
	file.close()
	print('Compiling:', 'rc_compile.lua')
	node.compile('rc_compile.lua')
	file.remove('rc_compile.lua')
	collectgarbage()
end
-- comment out this line to save time once files have been compiled
dofile("rc_compile.lc")
collectgarbage()

print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

dofile("rc_timer.lc")
collectgarbage()
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

dofile("rc_gpio.lc")
collectgarbage()
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

--dofile("but.lc")
collectgarbage()
print("heap:     "..node.heap())
print("mem used: "..collectgarbage('count'))

local r = 0
print("check button in 0.5s, debug?")
led(512)
tmr.delay(500000)
led(1023)
r = gpio.read(io_but)

if flag_dsleep == false then
	if r == 0 then
		print("button presssed, delete config")
		file.remove('config.lua')
		file.remove('config.lc')
	end
	collectgarbage()
	dofile("rc_wifi.lc")
	tmr.alarm(tmr_work, 100, 1, function()
		if (flag_wifi == true) then
			tmr.stop(tmr_work)
			dofile("work.lc")
		end
	end)
else
	if r == 1 then
		dofile("sleep.lc")(1000, 60000)
	else
		print("button presssed, debug mode")
	end
end
