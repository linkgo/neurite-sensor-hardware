return function(f)
	file.open(f, "r")
	print(file.read(EOF))
	file.close()
end
