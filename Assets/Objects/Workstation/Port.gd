extends Node2D

export (int) var id
export (bool) var is_enabled = true
var cable = null

onready var connector = get_node("Sprite")
onready var computer = get_parent().get_parent()
onready var particles = get_node("Particles2D")

signal on_connection_changed

func is_empty() -> bool:
	return is_enabled and cable == null

func connect_cable(new_cable):
	if cable == new_cable:
		return
	if cable != null:
		cable.emit_signal("on_disconnected")
	cable = new_cable
	particles.emitting = true
	particles.restart()
	connector.visible = not is_empty()
