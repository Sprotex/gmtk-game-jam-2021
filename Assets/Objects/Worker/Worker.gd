extends KinematicBody2D

const MOVE_SPEED: float = 200.0
const EPS: float = 0.01
# anger increment per second of being unsatisfied
const ANGER_INCREMENT = 0.15

export (bool) var walk_while_working = false

onready var messageShowTimer: Timer = $MessageShowTimer
onready var bubble: Node2D = $Bubble
onready var message_manager = get_node("/root/MessageManager")
onready var anger_sprite = get_node("AngerSprite")

var next_will_fail = false
var _starting_position: Vector2
onready var _problems = []
var anger = 0
var _work_location: Vector2 = Vector2.INF
var lunch_break_start
var at_lunch = false
var next_walk_location: Vector2 = Vector2.INF
var walk_cooldown: float = 5.0
var walk_locations = [
	Vector2(1198, 222),
	Vector2(1384, 480),
	Vector2(120, 222),
	Vector2(898, 480),
]
var _has_lunch_break = true

class MsgQueueElement:
	var msg: String
	var time_remaining: float
	
	func init(msg: String, time_remaining: float):
		self.msg = msg
		self.time_remaining = time_remaining
		return self

var message_queue = []


class Problem:
	var from: String
	var to: String
	var progress: float = 0.0
	var length: float
	var is_new: bool = true
	var opening_message: String
	var reply_message: String
	var is_message_in_progress = false
	var current_signal_sender = null
	
	func init(from: String, to: String, var length: float = 1.5):
		self.to = to
		randomize()
		self.length = length + rand_range(-0.1, 0.1)
		var msgRequest = MessageManager.pick_first_message(from, to)
		self.opening_message = msgRequest.message
		self.reply_message = msgRequest.get_random_reply()
		return self
		
	func send_networking_message(from, to, prev: Dictionary):
		var cable_chain = []
		var closed = []
		var cable_chain_destinations = []
		var destination_workstation = null
		var workstation = LevelManager.workstations[to]
		while true:
			var to_cables = []
			for port in workstation.ports:
				if not port.is_empty():
					to_cables.append(port.cable)
			for cable in to_cables:
				if prev.has(cable) and not closed.has(cable):
					closed.append(cable)
					cable_chain.push_front(cable)
					cable_chain_destinations.push_front(prev.get(cable))
					break
			if cable_chain_destinations.front() == from:
				break
			else:
				var index = 0
				if cable_chain_destinations.front() != cable_chain.front().connections[index].computer:
					index = 1
				workstation = cable_chain.front().connections[index].computer
		# add cable at last position, mark from where im sending, then iterate over next connection if 
		# destination is not found at the end of this cable
		
		# then run the message
		var index = 0
		current_signal_sender = cable_chain[index].message_signals
		
		connect_signals()
		current_signal_sender.send_message(cable_chain, cable_chain_destinations, length)
	
	func connect_signals():
		current_signal_sender.connect("on_reached_destination", self, "handle_on_reached_destination")
		current_signal_sender.connect("on_relay_message", self, "handle_on_relay_message")
		current_signal_sender.connect("on_canceled_transmission", self, "handle_on_canceled_transmission")
	
	func disconnect_signals():
		current_signal_sender.disconnect("on_reached_destination", self, "handle_on_reached_destination")
		current_signal_sender.disconnect("on_relay_message", self, "handle_on_relay_message")
		current_signal_sender.disconnect("on_canceled_transmission", self, "handle_on_canceled_transmission")
	
	func handle_on_reached_destination():
		progress = 1.0
		disconnect_signals()
		
	func handle_on_relay_message(next_signal_sender):
		disconnect_signals()
		current_signal_sender = next_signal_sender
		connect_signals()
		
	func handle_on_canceled_transmission():
		is_message_in_progress = false
		disconnect_signals()
	
	func try_solve_from(name: String, delta: float):
		if is_message_in_progress:
			return
		if LevelManager.workers[to].at_lunch:
			return
		var prev = {}
		var workstation = LevelManager.workstations[name]
		var is_connected = workstation.try_send_message(to, prev)
		if is_connected:
			is_message_in_progress = true
			send_networking_message(workstation, to, prev)
		
	func is_solved():
		if LevelManager.workers[to].at_lunch:
			return false
		return progress == 1.0


func _ready():
	_starting_position = global_position
	_has_lunch_break = LevelManager._current_scene_index != 3 || get_work_location().x < 1100
	lunch_break_start = 11.5 + randf()
	LevelManager.workers[name] = self

func get_work_location():
	if _work_location == Vector2.INF:
		_work_location = LevelManager.workstations[name].global_position
	return _work_location


func _process(delta: float):
	message_queue_process(delta)
	anger -= ANGER_INCREMENT * delta
	anger = clamp(anger, 0, 5)
	anger_sprite.set_angriness(int(anger))
	
	var time = TimeManager.current_time()
	if walk_while_working:
		if time < lunch_break_start or (time > lunch_break_start + 1 and time < 17):
			work(delta)
		else:
			lunch_break(delta)
		return
		
	if time < lunch_break_start or (time > lunch_break_start + 1 and time < 17):
		if global_position.distance_squared_to(get_work_location()) > EPS:
			go_to_work(delta)
		else:
			at_lunch = false
			work(delta)
	elif time < 15:
		lunch_break(delta)
	else:
		go_home(delta)

# ================
#  CORE BEHAVIORS
# ================

func go_to_work(delta: float):
	GlobalNavigation.navigate(self, get_work_location(), MOVE_SPEED, delta)

func work(delta: float):
	if walk_while_working:
		work_walk(delta)
	if len(_problems) == 0: return
	# TODO problem solving
	var problem: Problem = _problems[0]
	
	problem.try_solve_from(name, delta)
	if problem.is_solved():
		if len(message_queue) > 0:
			var message: MsgQueueElement = message_queue[0]
			if message.time_remaining == -1:
				message_queue.pop_front()
		# say_text(MessageManager.pick_thanks_message(problem.to), 2.0)
		LevelManager.workers[problem.to].say_text(problem.reply_message, 2.0)
		_problems.pop_front()
		MessageManager.emit_signal("on_message_delivered")
		if anger > 1:
			anger -= 1
		next_will_fail = false
		return
	
	var prev_anger = anger
	anger += 2 * ANGER_INCREMENT * delta
	
	if LevelManager.tutorial:
		if LevelManager.score < 1 and anger > 0.5:
			anger = 0.5
		elif LevelManager.score < 2 and anger > 1.5:
			anger = 1.5
		elif LevelManager.score >= 2:
			anger -= 0.5 * ANGER_INCREMENT * delta
	
	if anger >= 5:
		anger = -1
		MessageManager.emit_signal("on_message_timedout")
		return
	if not BubbleManager.bubble_visible(self) or int(anger) != int(prev_anger):
		var msg
		if problem.is_new:
			msg = problem.opening_message
			problem.is_new = false
		else:
			msg = MessageManager.pick_anger_message(problem.to, int(anger))
		say_text(msg)


func work_walk(delta: float):
	if walk_cooldown <= 0 or next_walk_location == Vector2.INF:
		next_walk_location = walk_locations[randi() % len(walk_locations)]
		walk_cooldown = rand_range(5, 15)
		
	if next_walk_location.distance_squared_to(global_position) > EPS:
		GlobalNavigation.navigate(self, next_walk_location, MOVE_SPEED, delta)
	else:
		walk_cooldown -= delta


func go_home(delta: float):
	say_no_more()
	GlobalNavigation.navigate(self, _starting_position, MOVE_SPEED, delta)
	

func lunch_break(delta: float):
	if not at_lunch:
		say_no_more()
		if len(_problems) > 0:
			say_text(MessageManager.pick_hunger_message(_problems[0].to))
		at_lunch = true
		BubbleManager.override_bubble_location(self, global_position)
	GlobalNavigation.navigate(self, _starting_position, MOVE_SPEED * 2, delta)

# ==================
#  HELPER FUNCTIONS
# ==================

# Called from outer scope by timeline manager
func add_problem(target_name: String, time: float):
	_problems.push_back(
		Problem.new().init(name, target_name, time)
	)

# MESSAGING
	
func say_text(message: String, timeout = -1):	
	message_queue.push_back(MsgQueueElement.new().init(message, timeout))

	
func _change_parent(node: Node2D, new_parent):
	var old_position = node.global_position
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_position = old_position
	node.desired_position = old_position
	

func say_no_more():
	BubbleManager.hide_my_bubble(self)


func message_queue_process(delta: float):
	if len(message_queue) == 0:
		BubbleManager.hide_my_bubble(self)
		return
	
	var msg_queue_elem: MsgQueueElement = message_queue[0]
	if not LevelManager.workstations.has(name):
		return
	var work_location = LevelManager.workstations[name].global_position
	
	if msg_queue_elem.time_remaining == -1:
		if len(message_queue) > 1:
			message_queue.pop_front()
			# will be dealt with in later update
			return
		BubbleManager.show_bubble(self, msg_queue_elem.msg, work_location)
		return
	
	msg_queue_elem.time_remaining -= delta
	if msg_queue_elem.time_remaining <= 0:
		message_queue.pop_front()
		return
	BubbleManager.show_bubble(self, msg_queue_elem.msg, work_location)
