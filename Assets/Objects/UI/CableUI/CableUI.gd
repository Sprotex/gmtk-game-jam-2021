extends Control

export (NodePath) var player_path
onready var player = get_node(player_path)
onready var cable_connecting = player.get_node("CableConnecting")
onready var container = get_node("HBoxContainer")
onready var ui_instance = get_node("TextureRect")

func _ready():
	ui_instance.visible = false
	cable_connecting.connect("on_lose_cable", self, "remove_cable_ui")
	cable_connecting.connect("on_gain_cable", self, "add_cable_ui")

func add_cable_ui():
	var node = ui_instance.duplicate()
	node.visible = true
	container.add_child(node)

func remove_cable_ui():
	if container.get_child_count() > 0:
		container.get_child(0).queue_free()
