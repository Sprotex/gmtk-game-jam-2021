extends Node

export (String) var level_name

func _ready():
	TimeManager.reset()
	TimelineManager.init(level_name)



