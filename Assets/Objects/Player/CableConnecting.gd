extends Node

onready var interactor = get_parent().get_node("Interactor")
var near_computer = null
var cable_class = preload("res://Assets/Objects/Cable/Cable.tscn")
onready var cables = get_children()
onready var player = get_parent()
var near_areas = []

func _ready():
	for cable in cables:
		cable.init()

func _unplug_cable(cable, port):
	cable = port.cable
	if not cables.has(cable):
		cables.push_front(cable)
	port.cable = null
	var index = 0 if cable.connections[0] == port else 1
	cable.connections[index] = player

func _connect_cable(id):
	var port = near_computer.ports[id]
	if not cables.empty():
		var cable = cables[0]
		if cable.connections.empty(): # I am currently not carrying a cable
			if port.cable == null: # port is empty
				port.cable = cable
				cable.connections.push_back(port)
				cable.connections.push_back(player)
				cable.start_drawing()
			else: # disconnect the cable from occupied port, attach it to player
				_unplug_cable(cable, port)
		else: # I am currently carrying a cable
			if port.is_empty(): # I am connecting
				var connected_index = 1 if cable.connections[0] is PlayerBody else 0
				var unconnected_index = 1 - connected_index
				cable.connections[unconnected_index] = port
				port.cable = cable
				cable.start_drawing()
				cables.pop_front()
			elif cable.connections.has(port): # I am disconnecting and it's the cable I'm carrying
				cable = port.cable
				while not cable.connections.empty():
					cable.connections.pop_front()
				port.cable = null
				cable.stop_drawing()
	else:
		if not port.is_empty(): # can plug out occupied port
			_unplug_cable(port.cable, port)

func _process(_delta):
	if near_computer != null:
		if Input.is_action_just_pressed("use_1"):
			_connect_cable(0)
		if Input.is_action_just_pressed("use_2"):
			_connect_cable(1)
		if Input.is_action_just_pressed("use_3"):
			_connect_cable(2)

func _set_near_computer():
	near_computer = null
	if not near_areas.empty():
		var nearest_area = null
		var nearest_distance = 0
		for near_area in near_areas:
			var current_distance = near_area.global_position.distance_squared_to(interactor.global_position)
			if nearest_area == null or current_distance < nearest_distance:
				nearest_area = near_area
				nearest_distance = current_distance
		if nearest_area != null:
			near_computer = nearest_area.computer
			return

func _on_Interactor_area_entered(area):
	if area is ComputerArea:
		near_areas.append(area)
		_set_near_computer()

func _on_Interactor_area_exited(area):
	if area is ComputerArea:
		var area_index = near_areas.find(area)
		near_areas.remove(area_index)
		near_computer = null
		print("Remove near ", area.computer.computer_name)
		_set_near_computer()
