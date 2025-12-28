class_name GrappleHookPoint
extends Area3D
## A point the [Player] can fire a grappling hook to.

enum Target {
	## The player is not looking at the grapple hook point.
	NOT_TARGETED,
	## The player is looking at, and is in range of the grapple hook point.
	TARGETED,
	## The player is looking at and is out of range of the grapple hook point.
	INVALID_TARGET,
}

var targeted: Target = Target.NOT_TARGETED

@onready var _targeted_sprite: Sprite3D = $TargetedSprite
@onready var _invalid_target_sprite: Sprite3D = $InvalidTargetSprite


func _process(_delta: float) -> void:
	match targeted:
		Target.NOT_TARGETED:
			_targeted_sprite.hide()
			_invalid_target_sprite.hide()

		Target.TARGETED:
			_targeted_sprite.show()
			_invalid_target_sprite.hide()

		Target.INVALID_TARGET:
			_targeted_sprite.hide()
			_invalid_target_sprite.show()
