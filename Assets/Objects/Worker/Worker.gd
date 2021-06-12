extends KinematicBody2D

const MOVE_SPEED: float = 200.0
const EPS: float = 0.01
# anger increment per second of being unsatisfied
const ANGER_INCREMENT = 0.15

onready var messageShowTimer: Timer = $MessageShowTimer
onready var bubble: RichTextLabel = $BubbleText
onready var bubble_background: NinePatchRect = $BubbleBackground
onready var message_manager = get_node("/root/MessageManager")
onready var anger_sprite = get_node("AngerSprite")

var _starting_position: Vector2
var _problems = []
var anger = 0
export var work_location: Vector2


func _ready():
	_starting_position = global_position
	LevelManager.workers[name.to_lower()] = self


func _process(delta: float):
	anger -= ANGER_INCREMENT * delta
	anger = clamp(anger, 0, 4)
	anger_sprite.set_angriness(int(anger))
	
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

# ================
#  CORE BEHAVIORS
# ================

func go_to_work(delta: float):
	GlobalNavigation.navigate(self, work_location, MOVE_SPEED, delta)


func work(delta: float):
	if len(_problems) == 0: return
	# TODO problem solving
	var solved = LevelManager.workstations[name.to_lower()].try_send_message(_problems[0].to_lower())
	if solved:
		say_no_more()
		say_text(MessageManager.pick_thanks_message(_problems[0]), 2.0)
		_problems.pop_front()
		MessageManager.emit_signal("on_message_delivered")
		return
	
	var prev_anger = anger
	anger += 2 * ANGER_INCREMENT * delta
	if not bubble.visible or int(anger) != int(prev_anger):
		say_text(MessageManager.pick_message(_problems[0], int(anger)))
	

func go_home(delta: float):
	say_no_more()
	GlobalNavigation.navigate(self, _starting_position, MOVE_SPEED, delta)
	

func lunch_break(delta: float):
	say_no_more()
	pass

# ==================
#  HELPER FUNCTIONS
# ==================

# Called from outer scope by timeline manager
func add_problem(target_name: String):
	_problems.push_back(target_name)

# MESSAGING
	
func say_text(message: String, timeout = -1):
	if !messageShowTimer.is_stopped():
		messageShowTimer.stop()

	if timeout > 0:
		messageShowTimer.start(timeout)
		
	bubble.text = message
	bubble.visible = true
	bubble_background.visible = true
	
func say_no_more():
	bubble.visible = false
	bubble_background.visible = false


func _on_MessageShowTimer_timeout():
	say_no_more()
