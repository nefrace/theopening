extends Area2D

var player: Player
var sin_time: float = 0
var velocity: Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	var diff := player.position - position
	velocity.x = 70
	velocity.y = clamp(velocity.y + diff.normalized().y * 400 * delta, -60, 60)
	position += velocity * delta
	
