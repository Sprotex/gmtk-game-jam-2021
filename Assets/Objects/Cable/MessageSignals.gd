extends Node

onready var message_sprite = get_node("Sprite")
onready var message_tween = get_node("MessageTween")

signal on_reached_destination(node)
signal on_canceled_transmission

func send_message(cable_chain, cable_chain_destinations, hop_duration):
	message_sprite.visible = true
	message_tween.interpolate_property(
		message_sprite, "global_position"
		, cable_chain.front().connections[0].global_position, cable_chain.front().connections[1].global_position
		, hop_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	message_tween.connect("tween_completed", self, "handle_tween_completed")
	message_tween.start()

func handle_tween_completed(obj, key):
	message_tween.disconnect("tween_completed", self, "handle_tween_completed")
	message_sprite.visible = false
	emit_signal("on_reached_destination", null)
