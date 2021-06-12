extends Node

var anger_to_messages = []
const filenames = [
	'request_messages.txt',
	'anger_1_messages.txt',
	'anger_2_messages.txt',
	'anger_3_messages.txt',
	'anger_4_messages.txt',
];
var thanks_messages = []

signal on_message_delivered

func _ready():
	for filename in filenames:
		anger_to_messages.push_back(
			FileUtils.read_lines('res://Assets/Configs/' + filename)
		)
	thanks_messages = FileUtils.read_lines('res://Assets/Configs/thanks_messages.txt')


func pick_message(name: String, anger: int):
	var candidates = anger_to_messages[anger]
	var sentence = candidates[randi() % len(candidates)]
	return sentence.format({"name": capitalize_name(name)})
	

func pick_thanks_message(name: String) -> String:
	var sentence = thanks_messages[randi() % len(thanks_messages)]
	return sentence.format({"name": capitalize_name(name)})


func capitalize_name(name: String) -> String:
	var first_char = name[0].to_upper()
	var rest = name.substr(1)
	return first_char + rest
