extends Node

onready var interactor = get_parent().get_node("Interactor")
var near_computer = null
var cable_class = preload("res://Assets/Objects/Cable/Cable.tscn")
onready var cables = get_children()
onready var player = get_parent()

func _ready():
	for cable in cables:
		cable.init()

func _connect_cable(id):
	if not cables.empty():
		var cable = cables[0]
		var port = near_computer.ports[id]
		if cable.connections.empty(): # I am currently not carrying a cable
			if port.cable == null: # port is empty
				port.cable = cable
				cable.connections.push_back(port) 
				cable.connections.push_back(player)
				cable.start_drawing()
			else: # disconnect the cable from occupied port, attach it to player
				cable = port.cable
				cables.push_front(cable)
				port.cable = null
				var index = 0 if cable.connections[0] == port else 1
				cable.connections[index] = player
		else: # I am currently carrying a cable
			var computer_1_index = 1 if cable.connections[0] is PlayerBody else 0
			var computer_1 = cable.connections[computer_1_index].computer
			var computer_2 = near_computer
			cable.connections[1 - computer_1_index] = port
			port.cable = cable
			cable.start_drawing()
			cables.pop_front()

func _process(_delta):
	if near_computer != null:
		if Input.is_action_just_pressed("use_1"):
			_connect_cable(0)
		if Input.is_action_just_pressed("use_2"):
			_connect_cable(1)
		if Input.is_action_just_pressed("use_3"):
			_connect_cable(2)

func _on_Interactor_area_entered(area):
	if area is ComputerArea:
		near_computer = area.computer

func _on_Interactor_area_exited(area):
	if area is ComputerArea:
		near_computer = null
		var overlapping_areas = interactor.get_overlapping_areas()
		for overlapping_area in overlapping_areas:
			if overlapping_area is ComputerArea:
				near_computer = area.computer
				return
