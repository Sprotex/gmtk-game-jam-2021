extends Node

# How long is an hour in game, in seconds
const HOUR_LENGTH = 15
#const HOUR_LENGTH = 5

onready var _time: float = 7.5
onready var _duration = 0.0
var time_label: Label

func reset():
	_time = 7.5
	_duration = 0.0

func _process(delta):
	var converted_delta = delta * (1.0 / HOUR_LENGTH)
	_duration += converted_delta
	_time += converted_delta
	
	if _time >= 24:
		_time -= 24
	
	time_label.text = current_time_string()

func get_duration():
	return _duration

func current_time_string() -> String:
	var hours = int(_time)
	var minutes = int((_time - hours) * 60)
	return '%d:%02d' % [hours, minutes]

func current_time() -> float:
	return _time
