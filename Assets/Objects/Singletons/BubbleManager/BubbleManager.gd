extends Node

var bubble_holder
var bubble_scene = preload("res://Assets/Objects/Bubble/Bubble.tscn")
var bubbles = {}

func _ready():
	bubbles.clear()


func show_bubble(obj: Node, message: String, location: Vector2):
	var id = obj.get_instance_id()
	var bubble: Bubble
	if bubbles.has(id):
		bubble = bubbles[id]
		bubble.visible = true
	else:
		bubble = bubble_scene.instance()
		bubbles[id] = bubble
	
	bubble_holder.add_child(bubble)
	bubble.get_node("Text").bbcode_text = message
	bubble.desired_position = location
	bubble.global_position = location


func override_bubble_location(obj: Node, location: Vector2):
	var id = obj.get_instance_id()
	if not bubbles.has(id): return false
	var bubble = bubbles[id]
	
	bubble.override_position = location


func bubble_visible(obj: Node):
	var id = obj.get_instance_id()
	if not bubbles.has(id): return false
	var bubble = bubbles[id]
	return bubble != null and bubble.visible


func hide_my_bubble(obj: Node):
	if not bubble_visible(obj): return
	var bubble = bubbles[obj.get_instance_id()]
	if bubble == null: return
	
	bubble.visible = false
