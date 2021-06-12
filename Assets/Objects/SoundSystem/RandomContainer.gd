extends AudioStreamPlayer

export var pitch_variance = 0.05


var single_event
export(Array, Resource) var stepPath = []



func play_event():	
	single_event = AudioStreamPlayer.new()
	single_event.stream = load(stepPath[rand_range(0, stepPath.size())].resource_path)
	remove_child(single_event)
	add_child(single_event)
	single_event.set_pitch_scale(rand_range(1-pitch_variance, 1+pitch_variance))
	single_event.play()
	
