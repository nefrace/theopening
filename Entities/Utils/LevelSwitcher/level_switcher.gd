extends Area2D

@export_file var new_scene
@export var need_torch := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.holdingItem == null && need_torch:
			return
		var center := get_tree().root.get_camera_2d().get_screen_center_position() - Vector2(80, 72)
		var pos := body.position - center
		
		SceneManager.switch_to_file(new_scene, pos)
