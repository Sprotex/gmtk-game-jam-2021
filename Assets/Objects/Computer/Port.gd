extends Node2D

signal on_connected
signal on_disconnected

export (int) var id
var connected_node = null
onready var computer = get_parent().get_parent()

func connect_to(node):
	connected_node = node
