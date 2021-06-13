extends KinematicBody2D

const MOVE_SPEED: float = 200.0
const EPS: float = 0.01
# anger increment per second of being unsatisfied
const ANGER_INCREMENT = 0.15

onready var messageShowTimer: Timer = $MessageShowTimer
onready var bubble: Node2D = $Bubble
onready var message_manager = get_node("/root/MessageManager")
onready var anger_sprite = get_node("AngerSprite")

var next_will_fail = false
var _starting_position: Vector2
onready var _problems = []
var anger = 0
var _work_location: Vector2 = Vector2.INF


class Problem:
	var to: String
	var progress: float = 0.0
	var length: float = 2.0
	var is_message_in_progress = false
	var current_signal_sender = null
	
	func init(to: String, var length: float = 2.0):
		self.to = to
		self.length = length
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
		
		current_signal_sender.connect("on_reached_destination", self, "handle_on_reached_destination")
		current_signal_sender.connect("on_relay_message", self, "handle_on_relay_message")
		current_signal_sender.connect("on_canceled_transmission", self, "handle_on_canceled_transmission")
		current_signal_sender.send_message(cable_chain, cable_chain_destinations, length)
	
	func disconnect_signals():
		current_signal_sender.disconnect("on_reached_destination", self, "handle_on_reached_destination")
		current_signal_sender.disconnect("on_relay_message", self, "handle_on_relay_message")
		current_signal_sender.disconnect("on_canceled_transmission", self, "handle_on_canceled_transmission")
	
	func handle_on_reached_destination(obj):
		progress = 1.0
		disconnect_signals()
		
	func handle_on_relay_message(next_signal_sender):
		disconnect_signals()
		current_signal_sender = next_signal_sender
		current_signal_sender.connect("on_reached_destination", self, "handle_on_reached_destination")
		current_signal_sender.connect("on_relay_message", self, "handle_on_relay_message")
		current_signal_sender.connect("on_canceled_transmission", self, "handle_on_canceled_transmission")
		
	func handle_on_canceled_transmission():
		is_message_in_progress = false
		disconnect_signals()
	
	func try_solve_from(name: String, delta: float):
		if is_message_in_progress:
			return
		var prev = {}
		var workstation = LevelManager.workstations[name]
		var is_connected = workstation.try_send_message(to, prev)
		if is_connected:
			is_message_in_progress = true
			send_networking_message(workstation, to, prev)
		
	func is_solved():
		return progress == 1.0


func _ready():
	_starting_position = global_position
	LevelManager.workers[name] = self

func get_work_location():
	if _work_location == Vector2.INF:
		_work_location = LevelManager.workstations[name].global_position
	return _work_location


func _process(delta: float):
	anger -= ANGER_INCREMENT * delta
	anger = clamp(anger, 0, 5)
	anger_sprite.set_angriness(int(anger))
	
	var time = TimeManager.current_time()
	if time < 12 or (time > 13 and time < 17):
		if global_position.distance_squared_to(get_work_location()) > EPS:
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
	GlobalNavigation.navigate(self, get_work_location(), MOVE_SPEED, delta)

func work(delta: float):
	if len(_problems) == 0: return
	# TODO problem solving
	var problem: Problem = _problems[0]
	
	problem.try_solve_from(name, delta)
	if problem.is_solved():
		say_no_more()
		say_text(MessageManager.pick_thanks_message(problem.to), 2.0)
		_problems.pop_front()
		MessageManager.emit_signal("on_message_delivered")
		next_will_fail = false
		return
	
	var prev_anger = anger
	anger += 2 * ANGER_INCREMENT * delta
	if anger >= 5:
		MessageManager.emit_signal("on_message_failed")
		return
	if not BubbleManager.bubble_visible(self) or int(anger) != int(prev_anger):
		say_text(MessageManager.pick_message(problem.to, int(anger)))

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
func add_problem(target_name: String, time: float = 2.0):
	_problems.push_back(
		Problem.new().init(target_name, time)
	)

# MESSAGING
	
func say_text(message: String, timeout = -1):	
	if !messageShowTimer.is_stopped():
		messageShowTimer.stop()

	if timeout > 0:
		messageShowTimer.start(timeout)
	
	BubbleManager.show_bubble(self, message, bubble.global_position, timeout)
	
func _change_parent(node: Node2D, new_parent):
	var old_position = node.global_position
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_position = old_position
	

func say_no_more():
	BubbleManager.hide_my_bubble(self)


func _on_MessageShowTimer_timeout():
	say_no_more()
