extends Node

onready var message_sprite = get_node("Sprite")
onready var message_tween = get_node("MessageTween")
var current_cable = null

signal on_reached_destination(node)
signal on_canceled_transmission

func send_message(cable_chain, cable_chain_destinations, hop_duration):
	current_cable = cable_chain.front()
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

func handle_tween_completed(obj, key):
	disconnect_signals()
	message_sprite.visible = false
	emit_signal("on_reached_destination", null)

func handle_on_disconnected():
	disconnect_signals()
	message_sprite.visible = false
	message_tween.stop_all()
	emit_signal("on_canceled_transmission")
	
