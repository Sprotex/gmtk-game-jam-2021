extends Node


func _ready():
	GlobalNavigation._nodes.clear()
	for child in get_children():
		GlobalNavigation._nodes.push_back(child.global_position)
