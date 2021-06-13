extends Label

onready var connections_counter = get_node("/root/ConnectionsCounter")

func _ready():
	text = str(connections_counter.total_connections)
