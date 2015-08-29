print("start normal work")

print("job done")

if flag_dsleep == 1 then
	print("enter dsleep in 3 sec, wake up after 60 sec")
	tmr.alarm(5, 3000, 0, function() print("dsleep") node.dsleep(60000000) end)
end
