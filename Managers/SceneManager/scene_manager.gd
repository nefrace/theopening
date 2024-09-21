extends CanvasLayer

var mat : ShaderMaterial

func _ready() -> void:
	mat = $ColorRect.material

func switch_to_file(file: String, center_in: Vector2 = Vector2(80, 72), center_out: Vector2 = Vector2(80, 72)):
	mat.set_shader_parameter("center", center_in)
	await tween_in()
	get_tree().change_scene_to_file(file)
	mat.set_shader_parameter("center", center_out)
	await tween_out()
	
func switch_to_packed(scene: PackedScene, center_in: Vector2 = Vector2(80, 72), center_out: Vector2 = Vector2(80, 72)):
	mat.set_shader_parameter("center", center_in)
	await tween_in()
	get_tree().change_scene_to_packed(scene)
	mat.set_shader_parameter("center", center_out)
	await tween_out()


func tween_in():
	var i := 0
	var tw = get_tree().create_tween()
	tw.tween_property($ColorRect.material, "shader_parameter/radius", 0, 1).set_trans(Tween.TRANS_EXPO)
	await tw.finished

func tween_out():
	var i := 0
	var tw = get_tree().create_tween()
	tw.tween_property($ColorRect.material, "shader_parameter/radius", 320, 1).set_trans(Tween.TRANS_EXPO)
	await tw.finished
