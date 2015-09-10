return function(f)
	if file.open(f, "r") then
		print(file.read(EOF))
		file.close()
	else
		print("open failed")
	end
end
