extends AudioStreamPlayer

var bgm1 = preload("res://Assets/Audio/bgm.mp3")
var bgm2 = preload("res://Assets/Audio/bgm2.mp3")
var noise = preload("res://Assets/Audio/noise.mp3")
var bossfight = preload("res://Assets/Audio/mb boss.mp3")

@export var music: AudioStream:
	set(value):
		if music == value:
			return
		if is_playing():
			await stop_music()
		stream = value
		start_music()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	bus = "Music"

func start_music(time: float = 1):
	var t := get_tree().create_tween()
	play()
	volume_db = linear_to_db(0.001)
	t.tween_property(self, "volume_db", linear_to_db(1.0), time)
	await t.finished
		

func stop_music(time: float = 1):
	var t := get_tree().create_tween()
	t.tween_property(self, "volume_db", linear_to_db(0.001), time)
	await t.finished
	stop()
