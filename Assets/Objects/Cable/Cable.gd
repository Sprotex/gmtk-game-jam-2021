extends Node2D


onready var message_signals = get_node("MessageSignals")
var connections = []
var line2d: Line2D
var line2d_border: Line2D

func init():
	MessageManager.connect("on_message_failed", self, "set_lines_visibility", [false])
	line2d = get_node("Line2D")
	line2d_border = get_node("Line2DBorder")
	line2d.set_as_toplevel(true)
	line2d_border.set_as_toplevel(true)
	set_lines_visibility(false)

func set_lines_visibility(value: bool):
	line2d.visible = value
	line2d_border.visible = value

func start_drawing():
	line2d.points[0] = connections[0].global_position
	line2d.points[1] = connections[1].global_position
	line2d_border.points[0] = connections[0].global_position
	line2d_border.points[1] = connections[1].global_position
	set_lines_visibility(true)

func stop_drawing():
	set_lines_visibility(false)

func _process(_delta):
	if connections.size() >= 2 and visible:
		for connection in connections:
			if connection is PlayerBody:
				start_drawing()

func search(closed: Array, prev: Dictionary, receiver_name: String) -> bool:
	for connection in connections:
		if not connection is PlayerBody:
			var computer = connection.computer
			if computer.search(closed, prev, receiver_name):
				return true
	return false
