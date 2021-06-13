extends Node2D

onready var worker_name: String = get_parent().name
onready var anger_sprite = get_parent().get_node("AngerSprite")

var selected_hair = null

const HASH_A = 491
const HASH_B = 967
const HASH_C = 1039	

func _ready():
	var hair_selector = 0
	var hair_count = get_child_count()
	for letter in worker_name: 
		hair_selector = (hair_selector + HASH_A * ord(letter) + HASH_B) % HASH_C
	hair_selector = hair_selector % hair_count
	selected_hair = get_child(hair_selector)
	remove_child(selected_hair)
	anger_sprite.add_child(selected_hair)
	queue_free()
