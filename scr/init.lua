uart.setup(0,115200,8,0,1)
print("")

local s,err
if file.open("rc.lc") then
	file.close()
	s,err = pcall(function() dofile("rc.lc") end)
else
	s,err = pcall(function() dofile("rc.lua") end)
end
if not s then print(err) end
