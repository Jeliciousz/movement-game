class_name GrappleHookPoint extends Area3D


@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var targeted_sprite: Sprite3D = $TargetedSprite

@onready var invalid_target_sprite: Sprite3D = $InvalidTargetSprite


enum {NOT_TARGETED, TARGETED, INVALID_TARGET}


var targeted: int = NOT_TARGETED


func _process(_delta: float) -> void:
	match targeted:
		NOT_TARGETED:
			targeted_sprite.hide()
			invalid_target_sprite.hide()
		TARGETED:
			targeted_sprite.show()
			invalid_target_sprite.hide()
		INVALID_TARGET:
			targeted_sprite.hide()
			invalid_target_sprite.show()
