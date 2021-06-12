extends KinematicBody2D

class_name PlayerBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 20
var jumpForce: int = 600
var gravity: int = 800

var vel: Vector2 = Vector2()
var grounded: bool = false

onready var sprite = $tmp_player

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/LevelManager").player_reference = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
	vel = move_and_slide(vel, Vector2.UP)
	vel.y += gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce

	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
