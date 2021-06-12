extends Node2D

const SHAKE_SPEED = 150
const SHAKE_SCALE = 10
onready var sprites = get_children()
onready var original_position = position
onready var noise = OpenSimplexNoise.new()
var current_angriness_level = 0
var time_running = 0

func set_angriness(angriness_level: int): 
	current_angriness_level = clamp(angriness_level, 0, sprites.size() - 1)
	for sprite in sprites:
		sprite.visible = false
	sprites[current_angriness_level].visible = true

func _ready():
	randomize()
	noise.seed = randi()

func _process(delta):
	time_running += delta
	position = original_position
	if current_angriness_level >= 1:
		position.x += noise.get_noise_2d(time_running * SHAKE_SPEED * current_angriness_level, 0) * SHAKE_SCALE
		position.y += noise.get_noise_2d(time_running * SHAKE_SPEED * current_angriness_level, 1000) * SHAKE_SCALE * 0.2
