extends CharacterBody2D


const SPEED = 100.0

var nearItem: Node2D

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_item_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Items"):
		area.monitorable = false
		$Hand.remote_path = area.get_path()
