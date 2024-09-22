extends Node


var time : float = 0
var active : bool = false

func start():
	active = true

func _process(delta: float) -> void:
	time += delta

func stop():
	active = false


func get_string():
	var minutes : int = floor(GameTimer.time / 60.0)
	var seconds : int = int(GameTimer.time) % 60
	return "%d:%02d" % [minutes, seconds]
