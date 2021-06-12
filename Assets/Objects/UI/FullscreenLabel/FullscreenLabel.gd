extends ColorRect

onready var _tween = $Tween


func _ready():
	visible = true


func _on_Timer_timeout():
	_tween.interpolate_property(self, "modulate",
		Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.0,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	_tween.start()
