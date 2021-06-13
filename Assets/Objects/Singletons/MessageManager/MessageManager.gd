extends Node

var anger_to_messages = []
const filenames = [
	'anger_1_messages.txt',
	'anger_2_messages.txt',
	'anger_3_messages.txt',
	'anger_4_messages.txt',
];
var request_messages = []
var thanks_messages = []
var lunch_messages = []

class MessageRequest:
	var from: String
	var to: String
	var message: String
	var possible_replies: Array
	func init(from: String, to: String, message: String, possible_replies: Array):
		self.from = from
		self.to = to
		self.message = message
		self.possible_replies = possible_replies
		return self
	func parse_from(from: String, to: String, line: String):
		self.from = from
		self.to = to
		var splits = line.split(';')
		self.message = splits[0].format({"name": "[color=red]%s[/color]" % to})
		self.possible_replies= splits[1].split('|')
		return self
	func get_random_reply() -> String:
		var reply = possible_replies[randi() % len(possible_replies)]
		return reply.format({
			"name": from,
			"my_name": to,
			"my_name_lower": to.to_lower(),
			"random_letter_of_my_name": to[randi() % len(to)]
		})

signal on_message_delivered
signal on_message_timedout

func _ready():
	for filename in filenames:
		anger_to_messages.push_back(
			FileUtils.read_lines('res://Assets/Configs/' + filename)
		)
	request_messages = FileUtils.read_lines('res://Assets/Configs/request_messages.txt')
	thanks_messages = FileUtils.read_lines('res://Assets/Configs/thanks_messages.txt')
	lunch_messages = FileUtils.read_lines('res://Assets/Configs/lunch_messages.txt')


func pick_first_message(from: String, name: String) -> MessageRequest:
	var line = request_messages[randi() % len(request_messages)]
	return MessageRequest.new().parse_from(from, name, line)


func pick_anger_message(name: String, anger: int):
	anger = clamp(anger - 1, 0, len(anger_to_messages) - 1)
	var candidates = anger_to_messages[anger]
	var sentence = candidates[randi() % len(candidates)]
	return sentence.format({"name": "[color=red]%s[/color]" % name})
	

func pick_thanks_message(name: String) -> String:
	var sentence = thanks_messages[randi() % len(thanks_messages)]
	return sentence.format({"name": name})


func pick_hunger_message(name: String) -> String:
	var sentence = lunch_messages[randi() % len(lunch_messages)]
	return sentence.format({"name": "[color=red]%s[/color]" % name})
