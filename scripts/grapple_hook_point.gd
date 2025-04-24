class_name GrappleHookPoint extends Area3D


@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var indicator_sprite: Sprite3D = $IndicatorSprite

@onready var too_far_indicator_sprite: Sprite3D = $TooFarIndicatorSprite


enum {NotTargeted, Targeted, InvalidTarget}


var targeted := NotTargeted


func _process(delta: float) -> void:
	match targeted:
		NotTargeted:
			indicator_sprite.hide()
			too_far_indicator_sprite.hide()
		Targeted:
			indicator_sprite.show()
			too_far_indicator_sprite.hide()
		InvalidTarget:
			indicator_sprite.hide()
			too_far_indicator_sprite.show()
