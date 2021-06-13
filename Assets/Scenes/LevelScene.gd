extends Node

export (String) var level_name
export (String, MULTILINE) var timeline
onready var bubblesHolder = $Bubbles

func _ready():
	TimeManager.reset()
	TimelineManager.init(timeline)
