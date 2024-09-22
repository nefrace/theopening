extends Node
class_name LightsDoorOpener

	
@export var lights_active: StringName
@export var lights_not_active: StringName
@export_node_path("Door") var door: NodePath
var activated := false
var sfxPlayer: AudioStreamPlayer

func _ready():
	sfxPlayer = AudioStreamPlayer.new()
	sfxPlayer.stream = preload("res://Assets/Audio/sfx/sfx_puzzle_solved_jingle.mp3")
	add_child(sfxPlayer)

func _process(delta: float) -> void:
	var trigger = true
	for light in get_tree().get_nodes_in_group(lights_active):
		if !light.active:
			trigger = false
			break
	for light in get_tree().get_nodes_in_group(lights_not_active):
		if light.active:
			trigger = false 
			break
		
	if trigger && !activated:
		activated = true
		sfxPlayer.play()
		await sfxPlayer.finished
		var d := get_node(door)
		d.opened = true
		queue_free()
