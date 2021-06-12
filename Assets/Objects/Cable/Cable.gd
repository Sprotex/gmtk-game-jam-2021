extends Node2D

var connections = []
var line2d: Line2D

func init():
	line2d = get_node("Line2D")

func start_drawing():
	line2d.points[0] = connections[0].global_position
	line2d.points[1] = connections[1].global_position
	visible = true

func stop_drawing():
	visible = false

func _process(_delta):
	if connections.size() >= 2 and connections[1] is PlayerBody and visible:
		start_drawing()

func search(open: Array, closed: Array, receiver_name: String) -> bool:
	for connection in connections:
		if not closed.has(connection):
			open.append(connection)
	return true
