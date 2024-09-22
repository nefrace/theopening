extends Node2D
class_name Snake

@export var health = 30
var max_health = health
# Called when the node enters the scene tree for the first time.
func hit():
	health -= 1
	$Hit.play()
	modulate = Color.BLACK
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
	if health <= 0:
		MusicManager.stop_music()
		GameTimer.stop()

func _process(delta: float):
	$SnakeBar/Control/PanelContainer/Health.value = health
	if get_child_count() == 2:
		queue_free()
