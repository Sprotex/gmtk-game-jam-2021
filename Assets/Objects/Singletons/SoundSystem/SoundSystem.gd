extends Node

onready var connecting = get_node("Connect")
onready var jump = get_node("Jump")
onready var disconnecting = get_node("Disconnect")
onready var window_breaking = get_node("window breaking")
onready var message_delivered = get_node("Message delivered")
onready var deny = get_node("deny")
onready var fail_music = get_node("fail music")
onready var level_music = [
	get_node("ye old corporate boy"),
	get_node("admins of madness"),
	get_node("fury of hr")
]

func stop_music():
	fail_music.stop()
	for music in level_music:
		music.stop()

func play_music(index: int):
	level_music[index].play()

func play_fail():
	stop_music()
	fail_music.play()
