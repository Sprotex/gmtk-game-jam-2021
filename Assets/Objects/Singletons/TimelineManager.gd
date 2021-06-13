extends Node


var _timeline = []
var problems_spawned = 0


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
func init(timeline_string: String):
	_timeline = []
	var lines = timeline_string.split("\n")
	# first line is column names
	for i in range(1, len(lines)):
		var line = lines[i]
		if line == "": continue
		var parts = line.split(";")
		
		var time = parts[0].split(":")
		time = float(time[0]) + float(time[1]) / 60.0
		var from = parts[1]
		var to = parts[2]
		
		_timeline.push_back(TimelinePiece.new().init(time, from, to))


func _process(delta):
	if len(_timeline) == 0: return
	
	var time = TimeManager.tutorial_adjusted_time()
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
		problems_spawned += 1
		LevelManager.workers[from].add_problem(to, 1.5)
		
	
