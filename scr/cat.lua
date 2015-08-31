return function(f)
	print("args:"..f)
	file.open(f, "r")
	print(file.read(EOF))
	file.close()
end
