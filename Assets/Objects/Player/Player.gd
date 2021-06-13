extends KinematicBody2D

const EPS: float = 0.1

class_name PlayerBody

export (int) var cables_count = 3
onready var jumpSound = get_node("SoundSystem/Jump")

var controls_enabled = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 20
var jumpForce: int = 600

# XSpeed handling
var max_x_speed: int = 600
var x_speed: int = 4400
var slow_down_increment: int = 2200

# Falling
var gravity: int = 3200
var max_y_speed: int = 1500

# Jumping
var base_jump_force: int = 600
var additional_jump_force: float = 70
var max_jump_time: float = 0.15
var airtime:float = 0

var vel: Vector2 = Vector2()
var grounded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_manager = get_node("/root/LevelManager")
	level_manager.player_reference = self
	yield(get_tree(),"idle_frame")
	get_node("CableConnecting").set_cable_count(cables_count)

onready var sprite = $Sprite

func _physics_process(delta):
	# XSPEED
	if Input.is_action_pressed("move_left") and controls_enabled:
		vel.x -= x_speed * delta
	elif Input.is_action_pressed("move_right") and controls_enabled:
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
	
	# jump
	if is_on_floor():
		airtime = 0
		if Input.is_action_pressed("jump") and controls_enabled:
			jumpSound.play_event()
			vel.y = -base_jump_force
	
	airtime += delta
	if airtime < max_jump_time && Input.is_action_pressed("jump") and controls_enabled:
		vel.y -= additional_jump_force
