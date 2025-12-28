extends Node3D


var crouch_tween: Tween


func start_crouch_tween(crouch_height: float, duration: float) -> void:
	if crouch_tween:
		crouch_tween.kill()

	crouch_tween = create_tween().set_trans(Tween.TRANS_SINE)
	crouch_tween.tween_property(self, "position", Vector3(0.0, crouch_height, 0.0), duration)


func start_uncrouch_tween(standing_height: float, duration: float) -> void:
	if crouch_tween:
		crouch_tween.kill()

	crouch_tween = create_tween().set_trans(Tween.TRANS_SINE)
	crouch_tween.tween_property(self, "position", Vector3(0.0, standing_height, 0.0), duration)
