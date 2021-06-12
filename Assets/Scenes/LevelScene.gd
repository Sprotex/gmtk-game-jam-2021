extends Node

export (String) var level_name

func _ready():
	TimelineManager.init(level_name)



