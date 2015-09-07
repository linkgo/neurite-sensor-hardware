return function(t_in, t_out)
	print("enter dsleep in "..t_in.." msec, wake up after "..t_out.." msec")
	tmr.alarm(tmr_pwr, t_in, 0, function()
		print("finalize perifs")
		tmr.stop(tmr_com)
		tmr.stop(tmr_wifi)
		tmr.stop(tmr_led)
		tmr.stop(tmr_but)
		print("alive for "..string.format("%.3f", tmr.now()/1000000).." secs in total, dsleep now")
		node.dsleep(t_out*1000)
	end)
end

