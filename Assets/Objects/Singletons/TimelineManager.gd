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
	_timeline = []
	var lines = FileUtils.read_lines('res://Assets/Configs/%s.csv' % level_name)
	# first line is column names
	lines.pop_front()
	for line in lines:
		if line == "": continue
		var parts = line.split(";")
		
		var time = parts[0].split(":")
		time = float(time[0]) + float(time[1]) / 60.0
		var from = parts[1]
		var to = parts[2]
		
		_timeline.push_back(TimelinePiece.new().init(time, from, to))


func _process(delta):
	if len(_timeline) == 0: return
	
	var time = TimeManager.current_time()
	var next_piece = _timeline[0]
	
	if time > next_piece.time:
		_timeline.pop_front()
		var from = next_piece.from
		var to = next_piece.to
		if from == 'RANDOM':
			from = LevelManager.workers.keys()[randi() % len(LevelManager.workers.keys())]
		while to == 'RANDOM' or to == from:
			to = LevelManager.workers.keys()[randi() % len(LevelManager.workers.keys())]
		
		print("New request at %s from %s to %s" % [TimeManager.current_time_string(),from, to])
		LevelManager.workers[from].add_problem(to)
		
	
