extends Node2D

export (String) var computer_name
onready var ports = get_node("Ports").get_children()
onready var level_manager = get_node("/root/LevelManager")
onready var cables = []

func connect_to_player(id: int):
	ports[id].connect_to(level_manager.player_reference.get_node("CableConnecting"))

func connect_to_pc(id: int):
	ports[id].connect_to(level_manager.player_reference.get_node("CableConnecting"))

# receiver_name: which pc is receiving the message
# returns true when message arrived, false otherwise
func try_send_message(receiver_name: String) -> bool:
	var open = []
	var closed = []
	return _search(open, closed, receiver_name)
		
func _search(open: Array, closed: Array, receiver_name: String) -> bool:
	for cable in cables:
		if cable.search(open, closed, receiver_name):
			return true
	return false

func _process(_delta):
	if Input.is_key_pressed(KEY_KP_ENTER):
		if computer_name != "Alex":
			print("Send message from %s to %s: %s" % [computer_name, "Alex", var2str(try_send_message("Alex"))])
