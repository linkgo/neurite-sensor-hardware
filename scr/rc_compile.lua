-- Compile server code and remove original .lua files.
-- This only happens the first time afer the .lua files are uploaded.

local compileAndRemoveIfNeeded = function(f)
	if file.open(f) then
		file.close()
		print('Compiling:', f)
		node.compile(f)
		file.remove(f)
		collectgarbage()
	end
end

local serverFiles = {'httpserver.lua', 'httpserver-basicauth.lua', 'httpserver-conf.lua', 'httpserver-b64decode.lua', 'httpserver-request.lua', 'httpserver-static.lua', 'httpserver-header.lua', 'httpserver-error.lua'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()
