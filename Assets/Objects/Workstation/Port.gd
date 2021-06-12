extends Node2D

export (int) var id
var cable = null

onready var computer = get_parent().get_parent()

func connect_to(_cable):
	cable = _cable
