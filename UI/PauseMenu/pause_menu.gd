extends CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		%Container.visible = get_tree().paused
		%Continue.grab_focus()
		



func _on_continue_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%Container.visible = get_tree().paused


func _on_restart_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%Container.visible = get_tree().paused
	SceneManager.restart()


func _on_quit_pressed() -> void:
	get_tree().quit()
