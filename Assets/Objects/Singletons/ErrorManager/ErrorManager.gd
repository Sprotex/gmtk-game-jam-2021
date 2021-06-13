extends Node


onready var sound_system = get_node("/root/SoundSystem")
onready var error_message = preload("res://Assets/Objects/ErrorMessage/ErrorMessage.tscn")


func show_error(text: String):
	var error_instance = error_message.instance()	
	error_instance.text = text
	var position = LevelManager.player_reference.global_position
	position.y -= 50
	error_instance.set_global_position(position)
	if LevelManager.error_messages != null:
		LevelManager.error_messages.add_child(error_instance)
	else:
		LevelManager.scene.add_child(error_instance)
	sound_system.deny.play_event()
