extends KinematicBody2D

const MOVE_SPEED: float = 2.0
const EPS: float = 0.01


onready var bubble: RichTextLabel = $BubbleText
onready var bubble_background: NinePatchRect = $BubbleBackground
onready var timer: Timer = $AngeringTimer
onready var message_manager = get_node("/root/MessageManager")


var anger = 0
export var work_location: Vector2


func _process(delta: float):
	var time = TimeManager.current_time()
	if time < 12 or (time > 13 and time < 17):
		if global_position.distance_squared_to(work_location) > EPS:
			go_to_work(delta)
		else:
			work(delta)
	elif time < 13:
		lunch_break(delta)
	else:
		go_home(delta)
	


func go_to_work(delta: float):
	global_position = global_position.move_toward(work_location, MOVE_SPEED)
	

func work(delta: float):
	if timer.is_stopped(): timer.start()
	

func go_home(delta: float):
	say_no_more()
	global_position.x += 1
	

func lunch_break(delta: float):
	say_no_more()
	pass

func _on_AngeringTimer_timeout():
	say_text(message_manager.pick_message('Alex', anger))
	anger += 1
	if anger > 4:
		anger = 0
		
		
func say_text(message: String):
	bubble.text = message
	bubble.visible = true
	bubble_background.visible = true
	
func say_no_more():
	bubble.visible = false
	bubble_background.visible = false
	timer.stop()
