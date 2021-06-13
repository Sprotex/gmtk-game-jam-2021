extends Node2D

class_name Bubble

var desired_position: Vector2 = Vector2.INF
var override_position: Vector2 = Vector2.INF

func _process(delta):
	if override_position != Vector2.INF:
		self.global_position = override_position
	
	var camera = LevelManager.camera
	if camera == null: return
	
	self.global_position = desired_position
	var camera_pos = camera.get_camera_screen_center()
	self.global_position.x = clamp(
		self.global_position.x,
		camera_pos.x - 670,
		camera_pos.x + 670
	)
	self.global_position.y = clamp(
		self.global_position.y,
		camera_pos.y - 310,
		camera_pos.y + 500
	)
