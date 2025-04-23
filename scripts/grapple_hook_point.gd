class_name GrappleHookPoint extends Area3D


@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var indicator_sprite: Sprite3D = $IndicatorSprite

@onready var too_far_indicator_sprite: Sprite3D = $TooFarIndicatorSprite


var active: int = 0


func _process(delta: float) -> void:
	match active:
		0:
			indicator_sprite.hide()
			too_far_indicator_sprite.hide()
		1:
			indicator_sprite.show()
			too_far_indicator_sprite.hide()
		2:
			indicator_sprite.hide()
			too_far_indicator_sprite.show()
