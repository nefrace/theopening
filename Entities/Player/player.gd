extends CharacterBody2D

class_name Player

@export var controls_enabled := true
@export var invincible := false
@export var health := 5
var dead := false
var explosionScene = preload("res://Entities/Utils/Explosion/Explosion.tscn")

@export var SPEED = 100.0
const PICKUP_DISTANCE = 10

var nearItem: Node2D
var nearLight: Node2D
@export var holdingItem: Node2D



func _process(delta: float) -> void:
	var j := 1
	for live in %LIVES.get_children():
		var tex := live as TextureRect
		if j > health:
			tex.texture.region.position.x = 16
		else:
			tex.texture.region.position.x = 0
		j += 1
		
	if !is_instance_valid(holdingItem):
		holdingItem = null
		%Hand.remote_path = ""
	
	var items := get_tree().get_nodes_in_group("Items")
	$InteractLabel.visible = false
	nearItem = null
	for i in items:
		var item : Node2D = i as Node2D
		if item == holdingItem:
			continue
		if item.global_position.distance_to(position) < PICKUP_DISTANCE:
			nearItem = item
			$InteractLabel.visible = true
			break
	if nearLight != null:
		$InteractLabel.visible = true
	if Input.is_action_just_pressed("action") && controls_enabled && !dead:
		if nearLight == null:
			if nearItem != null && holdingItem == null:
				%Hand.remote_path = nearItem.get_path()
				holdingItem = nearItem
			elif holdingItem != null:
				%Hand.remote_path = ""
				holdingItem = null
		else:
			nearLight.extinguish()
			nearLight = null
			

func attack():
	if holdingItem != null:
		return
	var bodies : Array[Node2D] = $HitArea.get_overlapping_bodies()
	$Swing.play()
	if len(bodies) != 0:
		for body in bodies:
			if body.is_in_group("Hitable"):
				body.hit_trigger = true
	$AnimationTree.set("parameters/conditions/attack", true)
	await get_tree().create_timer(0.2).timeout
	$AnimationTree.set("parameters/conditions/attack", false)

func _physics_process(delta: float) -> void:
	var direction : Vector2
	if controls_enabled && !dead:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if Input.is_action_just_pressed("attack"):
			attack()
			
	if direction:
		var anim_dir := direction * Vector2(1, -1)
		$AnimationTree.set("parameters/conditions/idle", false)
		$AnimationTree.set("parameters/conditions/running", true)
		$AnimationTree.set("parameters/Attack/blend_position", anim_dir)
		$AnimationTree.set("parameters/Idle/blend_position", anim_dir)
		$AnimationTree.set("parameters/Running/blend_position", anim_dir)
		$AnimationTree.set("parameters/Hit/blend_position", anim_dir)
		$HitArea.look_at(position + direction)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		$AnimationTree.set("parameters/conditions/idle", true)
		$AnimationTree.set("parameters/conditions/running", false)

	move_and_slide()
	
	
func got_hit():
	$Hit.play()
	$AnimationTree.set("parameters/conditions/got_hit", true)
	await get_tree().create_timer(0.2).timeout
	$AnimationTree.set("parameters/conditions/got_hit", false)
	if health <= 0 && !dead:
		dead = true
		visible = false
		var explosion := explosionScene.instantiate()
		explosion.position = position
		explosion.radius = 20
		add_sibling(explosion)
		controls_enabled = false


func _on_light_trigger_area_entered(area: Area2D) -> void:
	var p = area.get_parent()
	if p.is_in_group("Light"):
		if !p.active && holdingItem != null && holdingItem.is_in_group("Light"):
			p.active = true
		elif p.active && nearLight == null:
			nearLight = p
			


func _on_light_trigger_area_exited(area: Area2D) -> void:
	nearLight = null
