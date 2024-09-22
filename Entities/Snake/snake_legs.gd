extends Area2D

var previous: Node2D 
var max_distance := 22

func _physics_process(delta: float) -> void:
	var diff := previous.position - position
	if diff.length_squared() > max_distance * max_distance:
		position = previous.position - diff.normalized() * max_distance
	
