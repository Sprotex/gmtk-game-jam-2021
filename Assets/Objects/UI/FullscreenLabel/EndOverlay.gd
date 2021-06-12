extends ColorRect


onready var _tween: Tween = $Tween
var _ending = false


func _process(delta):
	if not _ending and TimeManager.current_time() > 17.5:
		_tween.connect("tween_completed", self, "on_tween_completed")
		_tween.interpolate_property(self, "modulate",
			Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		_tween.start()
		_ending = true



func on_tween_completed(obj, key):
	LevelManager.go_to_next_scene()
