extends StaticBody2D
class_name Door

@export var initially_opened: bool
@export var key_id: StringName

var opened: bool:
	set(value):
		if value == true:
			$Collider.disabled = true 
			$Sprite.region_rect.position.y = 464
			$SfxOpen.play()
		else:
			$Collider.disabled = false 
			$Sprite.region_rect.position.y = 496
	get:
		return $Collider.disabled

# Called when the node enters the scene tree for the fiScalrst time.
func _ready() -> void:
	opened = initially_opened


func _on_key_area_area_entered(area: Area2D) -> void:
	if area.get_parent().key_id == key_id:
		set_deferred("opened", true)
		
		area.get_parent().queue_free()
		print($Collider.disabled)
