extends CharacterBody2D


const SPEED = 100.0
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
			
		

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		$AnimationPlayer.speed_scale = 0

	move_and_slide()
