extends Node2D

export (Resource) var nameplate
onready var ports = get_node("Ports").get_children()
onready var level_manager = get_node("/root/LevelManager")
onready var nameplateSprite = $Nameplate

func _ready():
	nameplateSprite.texture = nameplate
	LevelManager.workstations[name] = self

func _process(_delta):
	if Input.is_key_pressed(KEY_KP_ENTER):
		if name != "Alex":
			print("Send message from %s to %s: %s" % [name, "Alex", var2str(try_send_message("Alex"))])

# receiver_name: which pc is receiving the message
# returns true when message arrived, false otherwise
func try_send_message(receiver_name: String) -> bool:
	var closed = []
	return search(closed, receiver_name)

func search(closed: Array, receiver_name: String) -> bool:
	if receiver_name == name:
		return true
	if not closed.has(self):
		closed.append(self)
		var cables = []
		for port in ports:
			if port.cable != null:
				cables.append(port.cable)
		for cable in cables:
			var _cable_connections = ""
			if not (cable.connections[0] is PlayerBody or cable.connections[1] is PlayerBody):
				_cable_connections = "%s <-> %s" % [cable.connections[0].computer.name, cable.connections[1].computer.name]
			if cable.search(closed, receiver_name):
				return true
	return false
