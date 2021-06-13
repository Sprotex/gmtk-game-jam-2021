extends Node

export (int) var level_music = 0
export (String, MULTILINE) var timeline
export (bool) var tutorial = false

onready var bubblesHolder = $Bubbles
onready var sound_system = get_node("/root/SoundSystem")

func _ready():
	sound_system.stop_music()
	sound_system.play_music(level_music)
	LevelManager.tutorial = tutorial
	TimeManager.reset()
	TimelineManager.init(timeline)
