extends KinematicBody2D

const EPS: float = 0.1

var max_x_speed: int = 600
var x_speed: int = 4400
var slow_down_increment: int = 1500

var jump_force: int = 1000
var gravity: int = 3200
var max_y_speed: int = 900

var vel: Vector2 = Vector2()
var grounded: bool = false

onready var sprite = $tmp_player

func _physics_process(delta):
	# XSPEED
	if Input.is_action_pressed("move_left"):
		vel.x -= x_speed * delta
	elif Input.is_action_pressed("move_right"):
		vel.x += x_speed * delta
	else:
		var decrease_speed_by: float = slow_down_increment * delta
		if abs(vel.x) <= decrease_speed_by:
			vel.x = 0
		else:
			vel.x -= decrease_speed_by * sign(vel.x)
		
	vel.x = clamp(vel.x, -max_x_speed, max_x_speed)
	
	vel = move_and_slide(vel, Vector2.UP)
	if abs(vel.x) <= EPS:
		vel.x = 0
	
	vel.y += gravity * delta
	if vel.y > max_y_speed:
		vel.y = max_y_speed
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = -jump_force

	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
