local cnt = 0
tmr.alarm(tmr_com, 1000, 1, function()
	cnt = cnt + 1
	if flag_jobdone == true or cnt >= 300 then
		tmr.stop(tmr_com)
		if flag_jobdone == false then
			print("warining: sleep without job done!")
		end
		if flag_telnet == true then
			print("telnet connected, ignore sleep")
		else
			dofile("sleep.lc")(1000, 300000)
		end
	end
end)
