extends Node

onready var cable_message_class = preload("res://Assets/Objects/CableMessage/CableMessage.tscn")
var current_cable = null
var current_cable_chain = null
var current_cable_chain_destinations = null
var current_hop_duration = 0.0

signal on_reached_destination
signal on_relay_message(next_signal_sender)
signal on_canceled_transmission

func send_message(cable_chain, cable_chain_destinations, hop_duration):
	current_cable = cable_chain.front()
	if current_cable.connections[0] is PlayerBody or current_cable.connections[1] is PlayerBody:
		emit_signal("on_canceled_transmission")
		return
	if not (current_cable.connections[0].computer == cable_chain_destinations.front() 
		or current_cable.connections[1].computer == cable_chain_destinations.front()):
		emit_signal("on_canceled_transmission")
		return
	current_cable_chain = cable_chain
	current_cable_chain_destinations = cable_chain_destinations
	current_hop_duration = hop_duration
	var start_index = 0
	if current_cable.connections[start_index].computer != cable_chain_destinations.front():
		start_index = 1
	var end_index = 1 - start_index
	var start_position = current_cable.connections[start_index].global_position
	var end_position = current_cable.connections[end_index].global_position
	var cable_message = cable_message_class.instance()
	add_child(cable_message)
	var is_last_hop = cable_chain_destinations.size() == 1
	cable_message.set_cable_chain(cable_chain, cable_chain_destinations)
	cable_message.init_and_send(start_position, end_position, hop_duration, is_last_hop)
	connect_signals(cable_message)

func connect_signals(cable_message: CableMessage):
	cable_message.connect("on_message_delivered", self, "handle_on_message_delivered")
	cable_message.connect("on_message_failed", self, "handle_on_disconnected")
	cable_message.connect("on_message_relayed", self, "handle_on_message_relayed")

func disconnect_signals(cable_message):
	cable_message.disconnect("on_message_delivered", self, "handle_on_message_delivered")
	cable_message.disconnect("on_message_failed", self, "handle_on_disconnected")
	cable_message.disconnect("on_message_relayed", self, "handle_on_message_relayed")

func handle_on_message_delivered(cable_message):
	disconnect_signals(cable_message)
	emit_signal("on_reached_destination")

func handle_on_message_relayed(cable_message):
	disconnect_signals(cable_message)
	cable_message.cable_chain.pop_front()
	cable_message.cable_chain_destinations.pop_front()
	var next_signal_sender = cable_message.cable_chain.front().message_signals
	emit_signal("on_relay_message", next_signal_sender) # tohle se nepripojuje
	next_signal_sender.send_message(cable_message.cable_chain, cable_message.cable_chain_destinations, current_hop_duration)

func handle_on_disconnected(cable_message):
	disconnect_signals(cable_message)
	emit_signal("on_canceled_transmission")

func _on_Cable_on_disconnected():
	for cable_message in get_children():
		cable_message.cancel_message()
