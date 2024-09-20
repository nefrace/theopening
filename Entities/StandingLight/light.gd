extends Sprite2D

@export var active: bool:
	set(value):
		if value:
			$Flame.scale = Vector2.ZERO
			$Flame.show()
			get_tree().create_tween().tween_property($Flame, "scale", Vector2.ONE, 0.4)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		else:
			$Flame.hide()
	get:
		return $Flame.visible
# Called when the node enters the scene tree for the first time.
