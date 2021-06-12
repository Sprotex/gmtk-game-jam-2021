extends Node

var player_reference

var workers: Dictionary
var workstations: Dictionary


func _ready():
	reset()


func reset():
	workers = {}
	workstations = {}


var scene_sequence = [
	'res://Assets/Scenes/Level1Scene.tscn',
	'res://Assets/Scenes/Level2Scene.tscn',
	'res://Assets/Scenes/Level3Scene.tscn',
]
var _current_scene_index = 0


func go_to_next_scene():
	_current_scene_index += 1
	
	if _current_scene_index >= len(scene_sequence):
		printerr("Cannot advance to next scene!")
		get_tree().quit()
		return
	
	for worker in workers.values():
		worker._problems = []
	reset()
	get_tree().change_scene(scene_sequence[_current_scene_index])
	
	
