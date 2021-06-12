extends Node


func read_lines(file_name: String):
	var f = File.new()
	var error = f.open(file_name, File.READ)
	
	if error:
		printerr("Couldn't open file %s" % file_name)
		return []
	
	var lines = []
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		if len(line) == 0: continue
		lines.push_back(line)

	f.close()
	return lines
	
