extends CanvasLayer

@export_file var menuScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		%Control.visible = get_tree().paused
		%Continue.grab_focus()
		%Timer.text = GameTimer.get_string()
		



func _on_continue_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%Control.visible = get_tree().paused


func _on_restart_pressed() -> void:
	get_tree().paused = !get_tree().paused
	%Control.visible = get_tree().paused
	SceneManager.restart()


func _on_quit_pressed() -> void:
	MusicManager.stop_music()
	get_tree().paused = !get_tree().paused
	%Control.visible = get_tree().paused
	SceneManager.switch_to_file(menuScene)
