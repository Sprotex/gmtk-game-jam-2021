extends Node2D


func _process(delta):
	get_parent().global_position = LevelManager.workers["CEO"].global_position

