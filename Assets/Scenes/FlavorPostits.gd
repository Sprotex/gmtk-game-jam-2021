extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var random_scale = 0.3
	for sprite in get_children():
		sprite.modulate.r -= randf() * random_scale
		sprite.modulate.g -= randf() * random_scale
		sprite.modulate.b -= randf() * random_scale
