extends Control

onready var label = get_node("HBoxContainer/Label")
var score = 0

func set_score(value: int):
	score = value
	LevelManager.score = score
	label.text = str(value)

func reset():
	set_score(0)

func _ready():
	MessageManager.connect("on_message_delivered", self, "_increment_score")
	reset()

func _increment_score():
	set_score(score + 1)
