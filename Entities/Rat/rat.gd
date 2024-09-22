extends CharacterBody2D

var health : int = 2
var seenPlayer: bool = false
var gotHit: bool = false
var active: bool = true
var explosionScene := preload("res://Entities/Utils/Explosion/Explosion.tscn")


var hit_trigger: bool:
	set(value):
		if gotHit:
			return
		gotHit = true
		health -= 1
		$Hit.play()
		$AnimationTree.set("parameters/conditions/got_hit", true)
		await get_tree().create_timer(0.3).timeout
		$AnimationTree.set("parameters/conditions/got_hit", false)
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
	$AnimationTree.set("parameters/conditions/run", true)
	look_at(player.position)
	rotation_degrees = floor((rotation_degrees - 45) / 90) * 90
	velocity = diff.normalized() * 30
	if active:
		if !gotHit:
			move_and_slide()
		if dist <= 25:
			startBite()
		
func startBite():
	active = false
	$AnimationTree.set("parameters/conditions/bite", true)
	await get_tree().create_timer(0.3).timeout
	$AnimationTree.set("parameters/conditions/bite", false)
	
func bite():
	active = true
	var bodies : Array[Node2D] = $PlayerBiter.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			body.health -= 1
			body.got_hit()
			print(body.health)
