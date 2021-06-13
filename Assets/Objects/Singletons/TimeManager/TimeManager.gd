extends Node

# How long is an hour in game, in seconds
const HOUR_LENGTH = 15
#const HOUR_LENGTH = 5

onready var _time: float = 7.5
onready var _duration = 0.0
var time_label: Label
# offset just for clock to facilitate tutorial
var _offset_time = 0.0

func reset():
	_time = 7.5
	_offset_time = 0.0
	_duration = 0.0

func _ready():
	reset()

func _process(delta):
	var converted_delta = delta * (1.0 / HOUR_LENGTH)
	if LevelManager.tutorial and TimelineManager.problems_spawned <= 2 and TimelineManager.problems_spawned != LevelManager.score:
		_offset_time -= converted_delta
		time_label.text = current_time_string()

	_duration += converted_delta
	_time += converted_delta
	
	if _time >= 24:
		_time -= 24
		
	if time_label != null:
		time_label.text = current_time_string()

func get_duration():
	return _duration

func current_time_string() -> String:
	var hours = int(_time)
	var minutes = int((_time - hours) * 60)
	if hours > 24: hours -= 24
	# ugly hack to monospace this font
	var time = '%d:%02d' % [hours, minutes]
	time = time.replace("1", " 1")
	while time[0] == ' ':
		time = time.substr(1)
	return time

func current_time() -> float:
	return _time

func tutorial_adjusted_time() -> float:
	return _time + _offset_time
