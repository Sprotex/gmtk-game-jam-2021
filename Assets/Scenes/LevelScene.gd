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
	LevelManager.scene = self
	TimeManager.reset()
	TimelineManager.init(timeline)

func _process(_delta):
	if Input.is_key_pressed(KEY_F10):
		LevelManager.go_to_next_scene()
