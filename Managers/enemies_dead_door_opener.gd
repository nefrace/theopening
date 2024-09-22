extends Node
class_name EnemiesDeadDoorOpener

	
@export_node_path("Door") var door: NodePath
@export var active := true
var activated := false

func _process(delta: float) -> void:
	if !active:
		return
	var group := get_groups()[0]
	var trigger = get_tree().get_node_count_in_group(group) == 1
	
	if trigger:
		var d := get_node(door)
		d.opened = true
		queue_free()
