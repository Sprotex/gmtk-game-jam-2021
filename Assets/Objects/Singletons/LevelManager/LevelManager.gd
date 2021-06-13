extends Node

var player_reference

var workers: Dictionary
var workstations: Dictionary
var camera: Camera2D = null
var tutorial: bool
var score: int
var scene: Node
var error_messages: Node2D


func _ready():
	reset()

func reset():
	randomize()
	workers = {}
	workstations = {}
	camera = null
	error_messages = null

var scene_sequence = [
	'res://Assets/Scenes/Level3Scene.tscn',
	'res://Assets/Scenes/Level4Scene.tscn',
	'res://Assets/Scenes/LevelVictory1.tscn'
]
var _current_scene_index = 0

func go_to_next_scene():
	_current_scene_index += 1
	
	if _current_scene_index >= len(scene_sequence):
		get_tree().quit()
		return
	
	for worker in workers.values():
		worker._problems = []
	reset()
	get_tree().change_scene(scene_sequence[_current_scene_index])
	
	
