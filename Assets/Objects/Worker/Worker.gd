extends KinematicBody2D

onready var bubble = $BubbleText
onready var timer = $AngeringTimer
onready var messageManager = get_node("/root/MessageManager")

var anger = 0

func say_text(message: String):
	bubble.text = message


func _on_AngeringTimer_timeout():
	say_text(messageManager.pick_message('Alex', anger))
	anger += 1
	if anger > 4:
		anger = 0
