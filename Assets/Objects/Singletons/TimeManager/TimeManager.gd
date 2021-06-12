extends Node

# How long is an hour in game, in seconds
const HOUR_LENGTH = 20

var _time: float = 7.5
var time_label: Label

func _process(delta):
	_time += delta * (1.0 / HOUR_LENGTH)
	if _time >= 24:
		_time -= 24
	
	time_label.text = current_time_string()

func current_time_string() -> String:
	var hours = int(_time)
	var minutes = int((_time - hours) * 60)
	return '%d:%02d' % [hours, minutes]

func current_time() -> float:
	return _time
