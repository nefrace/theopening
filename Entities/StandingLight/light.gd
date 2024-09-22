extends Sprite2D

@export var initially_active: bool = false
@export var active_timer: float = 0

@export var active: bool:
	set(value):
		if value:
			$Lit.play()
			$Flame.scale = Vector2.ZERO
			$Flame.show()
			get_tree().create_tween().tween_property($Flame, "scale", Vector2.ONE, 1)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			if active_timer > 0:
				await get_tree().create_timer(active_timer).timeout
				print(name)
				extinguish()
		else:
			await get_tree().create_tween().tween_property($Flame, "scale", Vector2.ZERO, 2)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).finished
			$Flame.hide()
	get:
		return $Flame.visible
# Called when the node enters the scene tree for the first time.

func light():
	active = true
	
func extinguish():
	active = false
	

func _ready() -> void:
	if active != initially_active:
		active = initially_active
	
func _process(delta: float) -> void:
	if active:
		for body in get_tree().get_nodes_in_group("Enemies"):
			if body.seenPlayer:
				continue
			var diff : Vector2 = body.position - $Flame.global_position
			if diff.length_squared() < 10000:
				body.seenPlayer = true
				
