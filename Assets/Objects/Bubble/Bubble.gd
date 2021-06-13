extends Node2D

class_name Bubble

var desired_position: Vector2 = Vector2.INF

func _process(delta):
	var camera = LevelManager.camera
	if camera == null: return
	
	self.global_position = desired_position
	var camera_pos = camera.get_camera_screen_center()
	self.global_position.x = clamp(
		self.global_position.x,
		camera_pos.x - 690,
		camera_pos.x + 690
	)
	self.global_position.y = clamp(
		self.global_position.y,
		camera_pos.y - 330,
		camera_pos.y + 450
	)
