class_name GrappleHookPoint extends Area3D


@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var targeted_sprite: Sprite3D = $TargetedSprite

@onready var invalid_target_sprite: Sprite3D = $InvalidTargetSprite


enum {NotTargeted, Targeted, InvalidTarget}


var targeted: int = NotTargeted


func _process(_delta: float) -> void:
	match targeted:
		NotTargeted:
			targeted_sprite.hide()
			invalid_target_sprite.hide()
		Targeted:
			targeted_sprite.show()
			invalid_target_sprite.hide()
		InvalidTarget:
			targeted_sprite.hide()
			invalid_target_sprite.show()
