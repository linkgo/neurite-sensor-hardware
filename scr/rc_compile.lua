print("# check compile")

-- Compile server code and remove original .lua files.
-- This only happens the first time afer the .lua files are uploaded.

local check_compile = function(f)
	if file.open(f) then
		file.close()
		print('Compiling:', f)
		node.compile(f)
		file.remove(f)
		collectgarbage()
	end
end

local files = {
	'but.lua',
	'cat.lua',
	'ls.lua',
	'lsap.lua',
	'rc_gpio.lua',
	'rc_i2c.lua',
	'rc.lua',
	'rc_timer.lua',
	'rc_wifi.lua',
	'run_config.lua',
	'sleep.lua',
	'tsl2561.lua',
	'work.lua',
}

for i, f in ipairs(files) do check_compile(f) end

check_compile = nil
files = nil
collectgarbage()
