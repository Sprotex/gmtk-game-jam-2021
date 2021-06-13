extends ColorRect

onready var _tween = $Tween


func _ready():
	var player: Node2D = LevelManager.player_reference
	player.controls_enabled = false
	# ugly hack to prevent player from showing for a frame
	player.z_index = -1
	visible = true


func _on_Timer_timeout():
	var player: Node2D = LevelManager.player_reference
	_tween.interpolate_property(self, "modulate",
		Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.0,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	player.controls_enabled = true
	player.z_index = 0
	_tween.start()
