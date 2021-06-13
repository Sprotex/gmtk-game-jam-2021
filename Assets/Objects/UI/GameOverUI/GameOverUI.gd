extends Control

onready var connections_enabled_label = get_node("ConnectionsEnabledLabel")
onready var time_worked_label = get_node("TimeWorkedLabel")
onready var connections_enabled_count = 0
onready var level_manager = get_node("/root/LevelManager")

func _ready():
	Engine.time_scale = 1.0
	TimeManager.get_duration()
	MessageManager.connect("on_message_timedout", self, "game_over")
	MessageManager.connect("on_message_delivered", self, "handle_deliver_message")

func _process(_delta):
	if Input.is_key_pressed(KEY_KP_0):
		game_over()

func handle_deliver_message():
	connections_enabled_count += 1

func game_over():
	emit_signal("on_game_over")
	Engine.time_scale = 0.0
	connections_enabled_label.text = str(connections_enabled_count)
	var time = int(TimeManager.get_duration())
	var hours = int(time)
	var minutes = int((time - hours) * 60)
	time_worked_label.text = "%d:%02d" % [hours, minutes]
	visible = true
	level_manager.player_reference.visible = false
	MessageManager._ready()

func _on_PlayAgainButton_pressed():
	Engine.time_scale = 1.0
	visible = false
	get_tree().reload_current_scene()
	TimeManager.reset()