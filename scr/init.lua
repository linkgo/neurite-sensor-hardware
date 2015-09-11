uart.setup(0,115200,8,0,1)
print("")
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
if file.open('rc_compile.lc') then
	dofile("rc_compile.lc")
end

local s,err
if file.open("rc.lc") then
	file.close()
	s,err = pcall(function() dofile("rc.lc") end)
else
	s,err = pcall(function() dofile("rc.lua") end)
end
if not s then print(err) end
