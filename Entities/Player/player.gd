extends CharacterBody2D

@export var controls_enabled := true
@export var invincible := false

@export var SPEED = 100.0
const PICKUP_DISTANCE = 10

var nearItem: Node2D
var holdingItem: Node2D

func _process(delta: float) -> void:
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
	if Input.is_action_just_pressed("action"):
		if nearItem != null && holdingItem == null:
			$Hand.remote_path = nearItem.get_path()
			holdingItem = nearItem
		elif holdingItem != null:
			$Hand.remote_path = ""
			holdingItem = null
			

func attack():
	$AnimationTree.set("parameters/conditions/attack", true)
	await get_tree().create_timer(0.2).timeout
	$AnimationTree.set("parameters/conditions/attack", false)

func _physics_process(delta: float) -> void:
	var direction : Vector2
	if controls_enabled:
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
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		$AnimationTree.set("parameters/conditions/idle", true)
		$AnimationTree.set("parameters/conditions/running", false)

	move_and_slide()


func _on_light_trigger_area_entered(area: Area2D) -> void:
	var p = area.get_parent()
	if p.is_in_group("Light") && !p.active && holdingItem != null && holdingItem.is_in_group("Light"):
		p.active = true
