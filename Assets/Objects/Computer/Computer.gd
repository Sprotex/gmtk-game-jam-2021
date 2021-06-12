extends Node2D

export (String) var computer_name
onready var ports = get_node("Ports").get_children()
onready var level_manager = get_node("/root/LevelManager")
onready var cables = []

func connect_to_player(id: int):
	ports[id].connect_to(level_manager.player_reference.get_node("CableConnecting"))

func connect_to_pc(id: int):
	ports[id].connect_to(level_manager.player_reference.get_node("CableConnecting"))
