extends KinematicBody2D

onready var bubble = $BubbleText
onready var timer = $AngeringTimer

func _ready():
	timer.start()


func say_text(message: String):
	bubble.text = message


func _on_AngeringTimer_timeout():
	say_text('I am very angry at you, Alex!')
