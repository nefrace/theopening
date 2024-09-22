extends CharacterBody2D

var health : int = 2
var seenPlayer: bool = false
var gotHit: bool = false
var active: bool = true
var explosionScene := preload("res://Entities/Utils/Explosion/Explosion.tscn")
var sinTimer: float = 0
var canBite: bool = true


var hit_trigger: bool:
	set(value):
		$AudioStreamPlayer2D.play()
		velocity = (position - player.position).normalized() * 20
		if gotHit:
			return
		gotHit = true
		health -= 1
		await get_tree().create_timer(0.3).timeout
		gotHit = false
		if health <= 0:
			var explosion := explosionScene.instantiate()
			explosion.position = position
			explosion.radius = 14
			explosion.lifetime = 0.3
			add_sibling(explosion)
			queue_free()
	
var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player.dead:
		return
	var diff := player.position - position
	var dist := diff.length()
	if !seenPlayer:
		if dist < 50:
			$RayCast2D.enabled = true
			$RayCast2D.target_position = diff
			if $RayCast2D.is_colliding():
				var body = $RayCast2D.get_collider()
				if body.is_in_group("Player"):
					seenPlayer = true
		return
	velocity = velocity.move_toward(diff.normalized() * 40, 30 * delta)
	move_and_slide()
	if active:
		if dist <= 25:
			if canBite:
				bite()
		
	
func bite():
	active = false 
	canBite = false
	var bodies : Array[Node2D] = $PlayerBiter.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			body.health -= 1
			body.got_hit()
			print(body.health)
	await get_tree().create_timer(0.3).timeout
	active = true 
	await get_tree().create_timer(1).timeout
	canBite = true
