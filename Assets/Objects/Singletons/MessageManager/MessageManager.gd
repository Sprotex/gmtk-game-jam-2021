extends Node

var anger_to_messages = [
	[ # Anger 1
		"Dear {name}, please reply ASAP",
		"{name}? Are you there?",
		"I really need it, {name}",
		"I like you, {name}, don't make me change that",
		"Yeah, I really need you to reply, {name}",
		"C'mon {name}, I thought we were friends...",
		"'Sup dog, {name}, could ya take a look?",
		"Looking forward to hearing from you, {name}",
		"If more convenient, send a pidgeon, {name}",
		"Did you get my message, {name}?",
	],
	[ # Anger 2
		"Are you trying to make me upset, {name}?",
		"You should reply, {name}",
		"C'mon {name}, don't play with me",
		"I sent you an e-mail, {name}!",
		"A response would be adequate, {name}!",
		"I ain't got all day, {name}!",
		"My temperature is rising, {name}!",
		"Send me instructions, {name}!",
		"P.S.: Reply soon, {name}.",
	],
	[ # Anger 3
		"I am angry at you, {name}!",
		"Stop stalling {name}!",
		"Shut.. I mean start talking, {name}!",
		"Gosh darnit, {name}! Reply!",
		"Are you deaf, {name}?!",
		"Guess which finger am I holding up, {name}!",
		"My grandmother could reply faster than you, {name}!",
		"Wake up, sheeple and {name}!",
		"If you don't reply, {name}, I don't think I can help you.",
		"Are you messing with me, {name}?",
	],
	[ # Anger 4 (last warning)
		"Last chance or {name} is no more",
		"I will fire you, {name}!",
		"This is your last warning, {name}!",
		"I am this close to reporting you, {name}!",
		"Do you like this job, {name}?!",
		"Final warning, {name}!",
		"I swear, {name}, reply to me or else!",
		"I will find somebody else named {name}, wait and see!",
		"{name}, would you reply faster if the office was on fire?",
		"Ignore me more and stuff is gonna go down, {name}!"
	]
]
var request_messages = [
	"Hey {name}, can you help me open this file?;Just left-click it|Sure|Here is a video that explains it",
	"{name}, what is your e-mail address?;It's {my_name_lower}.company.co|me@{my_name_lower}.com|{my_name_lower}@shady.video",
	"How are you doing, {name}?;Good, you?|Bad, you?|Alright, alright, alright.",
	"Heyyy {name}, I need you to work on Saturday;I would rather quit|No problem|Again?!",
	"{name}, could you help me buy Bitcoin?;What's that?|Yes, I can even sell you some|I don't know what it is.",
	"Please, {name}, how do I open e-mail?;Here is a video that explains it|Just left-click it|You just sent me one, wtf?",
	"{name}, can you erase the pictures I sent you?;Already did|No, I am uploading them online|No, they may come handy",
	"Would you like to have a drink someday, {name}?;What about right now?|Yeah, but not today|Not really, mate.",
	"Yo {name}, check out this sick website!;Nice, did you make it yourself?|Thanks, I hate it|Don't interupt me from work",
	"Please like and subscribe on my video, {name}!;Never!|Sure|I don't believe in the internet",
	"Did you get this e-mail {name}? Please reply.;Reply|Yes|Please stop sending me chain e-mails",
	"Will you forgive for what I did, {name}?;All is forgiven|Already got my revenge|I don't think I can",
	"Do you even love me, {name}?;I love you always|New PC, who dis?|I never did",
	"Can we stop hating each other, {name}?;I like hating people|I don't hate you, you hate me?|Yeah, sure",
	"Would you like to stay friends, {name}?;We are not friends.|I wanted more than friends|Okay, let's be friends",
	"Share this pic on your page, {name}!;Share it yourself first|Haha, sure|I don't know how to do that",
	"{name} pls, how do you spell your name?;Like just wrote it|{my_name}, but the {random_letter_of_my_name} is silent|{my_name} McShobobolama|{my_name}-san",
	"Who is {name}?;Me is... I am {my_name}|Seriously? We know each other from high school.|I don't know, but you are {name}",
	"Who do you think should run this company, {name}?;{random_name} should run this company|Well, not {name}...|Anybody except {random_name}, for sure",
	"What is this company actually doing, {name}?;I don't know, I just text people|I don't care|Better not ask questions or you'll get fired",
	"I need to perform cable test to {name};Cable attached, message received|I got your message after a guy plugged me in",
	"Help {name}, I appear to be disconnected;Yeah, a guy here keeps disconnecting people|I got problems too|Call the IT guy to fix it",
	"Hey {name}, I haven't heard from you forever!;Yes, I talked to you last at 8:00|I know, I missed you too|How about we go to lunch someday?",
	"{name}, what time is it?;I dunno, why is the clock by the stairs?|Showtime!|Doesn't matter, it keeps changing awfully fast"
]
var thanks_messages = [
	"Well, finally!",
	"Thanks!",
	"It wasn't that hard, was it?",
	"Brilliant!",
	"Awesome answer.",
	"Got it.",
	"Wow, thanks, but why so rude?",
	"I love you.",
	"Wow, that was fast!",
	"Sweet bajeebus, that was a large attachment.",
	"A precious little piece of data.",
	"I am sending you an e-mail as a reward.",
	"Really? THAT is your response?",
]
var lunch_messages = [
	"You better get this done while I am at lunch, {name}!",
	"I better have this in my inbox after lunch, {name}...",
	"You have 1 hour, {name}.",
	"I need to take a walk, {name}, get back to me.",
	"I have almost smashed my keyboard, I need to walk it off, {name}.",
	"I feel no stress, {name}.",
	"I am taking a walk because I want to, not because I need to, {name}.",
	"Is that free pizza over there? brb, {name}.",
	"Did I leave the oven on? See you later, {name}.",
	"I will get a beer, {name}, chill on this.",
	"I will go to lunch before I lose my senses, {name}!"
]

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
			"random_letter_of_my_name": to[randi() % len(to)],
			"random_name": LevelManager.workers.keys()[randi() % len(LevelManager.workers.keys())]
		})

signal on_message_delivered
signal on_message_timedout


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
