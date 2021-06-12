extends Node

onready var message_sprite = get_node("Sprite")
onready var message_tween = get_node("MessageTween")
var current_cable = null

signal on_reached_destination(node)
signal on_canceled_transmission

func send_message(cable_chain, cable_chain_destinations, hop_duration):
	current_cable = cable_chain.front()
	message_tween.interpolate_property(
		message_sprite, "global_position"
		, current_cable.connections[0].global_position, current_cable.connections[1].global_position
		, hop_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	current_cable.connections[0].connect("on_connection_changed", self, "handle_on_connection_changed")
	current_cable.connections[1].connect("on_connection_changed", self, "handle_on_connection_changed")
	message_tween.connect("tween_completed", self, "handle_tween_completed")
	message_tween.start()
	message_sprite.global_position = current_cable.connections[0].global_position
	message_sprite.visible = true

func disconnect_signals():
	message_tween.disconnect("tween_completed", self, "handle_tween_completed")
	current_cable.connections[0].connect("on_connection_changed", self, "handle_on_connection_changed")
	current_cable.connections[1].connect("on_connection_changed", self, "handle_on_connection_changed")
	

func handle_tween_completed(obj, key):
	disconnect_signals()
	message_sprite.visible = false
	emit_signal("on_reached_destination", null)

func handle_on_connection_changed():
	disconnect_signals()
	message_sprite.visible = false
	message_tween.stop_all()
	emit_signal("on_canceled_transmission")
	
