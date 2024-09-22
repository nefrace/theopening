extends Area2D

class_name SnakeHead

var sin_time: float = 0
var velocity: Vector2 = Vector2.RIGHT
var parent: Snake
var dead := false
@export var segments : int = 30
var segment := preload("res://Entities/Snake/snake_legs.tscn")
var explosion := preload("res://Entities/Utils/Explosion/Explosion.tscn")
@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	parent = get_parent()
	var currentSegment = self
	for i in range(segments):
		print(i)
		var s := segment.instantiate()
		s.position = position - Vector2.RIGHT * 20
		s.previous = currentSegment
		s.head = self
		call_deferred("add_sibling", s)
		currentSegment = s

func death():
	$Dead.play()
	await get_tree().create_timer(randf_range(0.5, 4)).timeout
	var e := explosion.instantiate()
	e.position = position
	e.radius = randf_range(16, 22)
	queue_free()
	add_sibling(e)

func _process(delta: float) -> void:
	if parent.health <= 0 && !dead:
		dead = true
		death()
		return
		
	sin_time += delta
	var diff := player.position - position
	var dir := diff.angle()
	var dir_diff := velocity.angle_to(diff)
	dir += sin(sin_time * PI)
	velocity = velocity.move_toward(diff.normalized() * 100, 120 * delta)
	var vel : float = clamp(velocity.length(), 70, 100)
	velocity = velocity.normalized() * vel
	#velocity = velocity.rotated(sign(dir_diff) * delta).normalized() * 80
	position += velocity * delta
	$Sprite.rotation = velocity.angle() + PI
	$Sprite.rotation_degrees = floor(($Sprite.rotation_degrees - 45) / 90) * 90
	
func hit():
	parent.hit()


func _on_hitter_body_entered(body: Node2D) -> void:
	if body is Player:
		body.got_hit()
