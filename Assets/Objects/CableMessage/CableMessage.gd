extends Node2D

class_name CableMessage

signal on_message_delivered(cable_message)
signal on_message_relayed(cable_message)
signal on_message_failed(cable_message)

onready var sound_system = get_node("/root/SoundSystem")
onready var message_tween = get_node("MessageTween")
onready var sprite = get_node("Sprite")
var is_last_hop = false
var cable_chain = []
var cable_chain_destinations = []

func set_cable_chain(_cable_chain, _cable_chain_destinations):
	cable_chain = _cable_chain
	cable_chain_destinations = _cable_chain_destinations

func init_and_send(start_position: Vector2, end_object: Node2D, duration: float, _is_last_hop: bool):
	is_last_hop = _is_last_hop
	message_tween.follow_property(
		sprite, "global_position", start_position, end_object, "global_position"
		, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	message_tween.start()
	sprite.visible = true
	sprite.global_position = start_position

func cancel_message():
	sprite.visible = false
	emit_signal("on_message_failed", self)
	queue_free()

func _on_MessageTween_tween_completed(object, key):
	if is_last_hop:
		emit_signal("on_message_delivered", self)
		sound_system.message_delivered.play_event()
	else:
		emit_signal("on_message_relayed", self)
	queue_free()
