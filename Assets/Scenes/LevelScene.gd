extends Node

export (String) var level_name
export (String, MULTILINE) var timeline
export (bool) var tutorial = false

onready var bubblesHolder = $Bubbles

func _ready():
	LevelManager.tutorial = tutorial
	TimeManager.reset()
	TimelineManager.init(timeline)
