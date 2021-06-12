extends Node2D

export (int) var id
var cable = null

onready var connector = get_node("Sprite")
onready var computer = get_parent().get_parent()

func is_empty() -> bool:
	return cable == null

func connect_cable(new_cable):
	cable = new_cable
	connector.visible = not is_empty()
