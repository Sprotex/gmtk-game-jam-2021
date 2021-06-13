extends Camera2D


export (NodePath) var camera_relative 

func _ready():
	LevelManager.camera = self
	

func _process(delta):
	get_node(camera_relative).global_position = self.get_camera_screen_center()
