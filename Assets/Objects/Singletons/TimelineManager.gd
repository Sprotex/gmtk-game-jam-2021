extends Node


var _timeline = []


class TimelinePiece:
	var time: float
	var from: String
	var to: String
	
	func init(time: float, from: String, to: String):
		self.time = time
		self.from = from
		self.to = to
		return self

# Called in _ready of LevelScene 
func init(level_name: String):
	var lines = FileUtils.read_lines('res://Assets/Configs/%s.csv' % level_name)
	# first line is column names
	lines.pop_front()
	for line in lines:
		if line == "": continue
		var parts = line.split(";")
		
		var time = parts[0].split(":")
		time = float(time[0]) + float(time[1]) / 60.0
		var from = parts[1].to_lower()
		var to = parts[2].to_lower()
		
		_timeline.push_back(TimelinePiece.new().init(time, from, to))


func _process(delta):
	if len(_timeline) == 0: return
	
	var time = TimeManager.current_time()
	var next_piece = _timeline[0]
	
	if time > next_piece.time:
		_timeline.pop_front()
		print("New request at %s from %s to %s" % [TimeManager.current_time_string(), next_piece.from, next_piece.to])
		LevelManager.workers[next_piece.from].add_problem(next_piece.to)
		
	
