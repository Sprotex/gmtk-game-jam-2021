extends Node


func read_lines(file_name: String):
	var f = File.new()
	f.open(file_name, File.READ)
	
	var lines = []
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		lines.push_back(line)

	f.close()
	return lines
	
