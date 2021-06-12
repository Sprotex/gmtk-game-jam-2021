extends Node

onready var message_sprite = get_node("Sprite")
onready var message_tween = get_node("MessageTween")
var current_cable = null
var current_cable_chain = null
var current_cable_chain_destinations = null
var current_hop_duration = 0.0

signal on_reached_destination(node)
signal on_relay_message(next_signal_sender)
signal on_canceled_transmission

func send_message(cable_chain, cable_chain_destinations, hop_duration):
	current_cable = cable_chain.front()
	current_cable_chain = cable_chain
	current_cable_chain_destinations = cable_chain_destinations
	current_hop_duration = hop_duration
	var start_index = 0
	if current_cable.connections[start_index].computer != cable_chain_destinations.front():
		start_index = 1
	var end_index = 1 - start_index
	message_tween.interpolate_property(
		message_sprite, "global_position"
		, current_cable.connections[start_index].global_position, current_cable.connections[end_index].global_position
		, hop_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	current_cable.connect("on_disconnected", self, "handle_on_disconnected")
	message_tween.connect("tween_completed", self, "handle_tween_completed")
	message_tween.start()
	message_sprite.global_position = current_cable.connections[start_index].global_position
	message_sprite.visible = true

func disconnect_signals():
	message_tween.disconnect("tween_completed", self, "handle_tween_completed")
	current_cable.disconnect("on_disconnected", self, "handle_on_disconnected")

func handle_tween_completed(_obj, _key):
	disconnect_signals()
	message_sprite.visible = false
	current_cable_chain.pop_front()
	current_cable_chain_destinations.pop_front()
	if current_cable_chain.empty():
		current_cable = null
		current_cable_chain = []
		current_cable_chain_destinations = []
		current_hop_duration = 0.0
		emit_signal("on_reached_destination", null)
	else:
		var next_signal_sender = current_cable_chain.front().message_signals
		next_signal_sender.send_message(current_cable_chain, current_cable_chain_destinations, current_hop_duration)
		emit_signal("on_relay_message", next_signal_sender)

func handle_on_disconnected():
	disconnect_signals()
	message_sprite.visible = false
	message_tween.stop_all()
	emit_signal("on_canceled_transmission")

