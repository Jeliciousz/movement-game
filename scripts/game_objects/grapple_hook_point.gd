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

@onready var targeted_sprite: Sprite3D = $TargetedSprite
@onready var invalid_target_sprite: Sprite3D = $InvalidTargetSprite


func _process(_delta: float) -> void:
	match targeted:
		Target.NOT_TARGETED:
			targeted_sprite.hide()
			invalid_target_sprite.hide()

		Target.TARGETED:
			targeted_sprite.show()
			invalid_target_sprite.hide()

		Target.INVALID_TARGET:
			targeted_sprite.hide()
			invalid_target_sprite.show()
