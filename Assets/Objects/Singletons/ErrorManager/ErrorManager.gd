extends Node


onready var error_message = preload("res://Assets/Objects/ErrorMessage/ErrorMessage.tscn")


func show_error(text: String):
	var error_instance = error_message.instance()	
	error_instance.text = text
	var position = LevelManager.player_reference.global_position
	position.y -= 50
	error_instance.set_global_position(position)
	LevelManager.scene.add_child(error_instance)
