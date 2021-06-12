extends Node

var anger_to_messages = []
const filenames = [
	'request_messages.txt',
	'anger_1_messages.txt',
	'anger_2_messages.txt',
	'anger_3_messages.txt',
	'anger_4_messages.txt',
];

func _ready():
	for filename in filenames:
		anger_to_messages.push_back(
			FileUtils.read_lines('res://Assets/configs/' + filename)
		)


func pick_message(name: String, anger: int):
	var candidates = anger_to_messages[anger]
	var sentence = candidates[randi() % len(candidates)]
	var first_char = name[0].to_upper()
	var rest = name.substr(1)
	return sentence.format({"name": first_char + rest})
