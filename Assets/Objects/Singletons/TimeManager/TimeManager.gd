extends Node

# How long is an hour in game, in seconds
const HOUR_LENGTH = 20

var _time: float = 7.5
var time_label: Label

func _process(delta):
	_time += delta * (1.0 / HOUR_LENGTH)
	var hours = int(_time)
	var minutes = int((_time - hours) * 60)
	var time_string = '%d:%02d' % [hours, minutes]
	time_label.text = time_string

func current_time():
	return _time
