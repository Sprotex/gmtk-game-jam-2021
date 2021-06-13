extends Node2D


func _process(delta):
	if not LevelManager.workers.has("CEO"):
		return
	get_parent().global_position = LevelManager.workers["CEO"].global_position

