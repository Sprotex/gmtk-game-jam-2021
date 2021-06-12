extends Node

export (String) var level_name
onready var bubblesHolder = $Bubbles

func _ready():
	TimeManager.reset()
	TimelineManager.init(level_name)
