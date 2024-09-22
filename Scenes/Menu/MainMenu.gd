extends CanvasLayer

@export_file var nextScene

func _ready() -> void:
	%Start.grab_focus()


func _process(_delta):
	if Input.is_anything_pressed() && %CreditsMenu.visible:
		%CreditsMenu.hide()
		%Menu.show()
		%Credits.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	SceneManager.switch_to_file(nextScene)


func _on_credits_pressed() -> void:
	%Menu.hide()
	%CreditsMenu.show()
