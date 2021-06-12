extends Node2D

export (int) var id
var connected_node = null
onready var computer = get_parent().get_parent()

func connect_to(node):
	connected_node = node
