extends AudioStreamPlayer

onready var music_event
onready var music_type

export(Array, Resource) var GameplayMusic = []
export(Array, Resource) var IntroMusic = []
export(Array, Resource) var FailMusic = []

onready var music_type_arr = [IntroMusic, GameplayMusic, FailMusic]

func play_music(index: int):
	music_type = music_type_arr[index%3]
	music_event = AudioStreamPlayer.new()
	music_event.stream = load(music_type[rand_range(0, music_type.size())].resource_path)
	#music_event.stream = music_type[rand_range(0,music_type.size())].resource_path
	remove_child(music_event)
	add_child(music_event)
	music_event.play()
