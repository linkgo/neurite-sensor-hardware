print("button")

local value = true
local t = 0
local dt = 0
local r_curr = 1
local r_prev = 1

function but_cb(dt)
	value = not value
	if value == false then
		print("low")
	else
		print("high")
	end
end

tmr.alarm(tmr_but, 50, 1, function()
	local r_curr = gpio.read(io_but)
	if r_curr == 0 and r_prev == 1 then
		t = tmr.now()
		r_prev = r_curr
	elseif r_curr == 1 and r_prev == 0 then
		dt = tmr.now() - t
		print("dt: "..dt)
		r_prev = r_curr
		if (dt > 139999) then but_cb(dt) end
	else
		-- do nothing
	end
end)
print("button [ok]")
