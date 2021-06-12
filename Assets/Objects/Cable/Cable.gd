extends Node2D

var connections = []
var line2d: Line2D

func init():
	line2d = get_node("Line2D")
	visible = false

func start_drawing():
	line2d.points[0] = connections[0].global_position
	line2d.points[1] = connections[1].global_position
	visible = true

func stop_drawing():
	visible = false

func _process(_delta):
	if connections.size() >= 2 and visible:
		for connection in connections:
			if connection is PlayerBody:
				start_drawing()

func search(closed: Array, receiver_name: String) -> bool:
	for connection in connections:
		var computer = connection.computer
		if computer.search(closed, receiver_name):
			return true
	return false
