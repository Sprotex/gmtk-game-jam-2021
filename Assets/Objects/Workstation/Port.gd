extends Node2D

export (int) var id
var cable = null

onready var computer = get_parent().get_parent()

func is_empty() -> bool:
	return cable == null
