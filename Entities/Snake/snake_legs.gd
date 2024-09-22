extends Area2D

var previous: Node2D 
var head: SnakeHead
var max_distance := 8
var explosion := preload("res://Entities/Utils/Explosion/Explosion.tscn")
var dead := false

func death():
	await get_tree().create_timer(randf_range(0.5, 4)).timeout
	var e := explosion.instantiate()
	e.position = position
	e.radius = randf_range(16, 22)
	queue_free()
	add_sibling(e)

func _process(delta: float) -> void:
	if head != null && head.parent.health <= 0 && !dead:
		dead = true
		death()
		return
		
	if previous == null:
		return
	var diff := previous.position - position
	if diff.length_squared() > max_distance * max_distance:
		position = previous.position - diff.normalized() * max_distance
	$Sprite.rotation = diff.angle() + PI
	$Sprite.rotation_degrees = floor(($Sprite.rotation_degrees - 45) / 90) * 90


func hit():
	head.parent.hit()


func _on_hitter_body_entered(body: Node2D) -> void:
	if body is Player:
		body.got_hit()
