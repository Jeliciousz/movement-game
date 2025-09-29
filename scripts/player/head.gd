extends Node3D


var _crouch_tween: Tween


func start_crouch_tween(crouch_height: float, duration: float) -> void:
	if _crouch_tween:
		_crouch_tween.kill()

	_crouch_tween = create_tween().set_trans(Tween.TRANS_SINE)
	_crouch_tween.tween_property(self, "position", Vector3(0.0, crouch_height, 0.0), duration)


func start_uncrouch_tween(standing_height: float, duration: float) -> void:
	if _crouch_tween:
		_crouch_tween.kill()

	_crouch_tween = create_tween().set_trans(Tween.TRANS_SINE)
	_crouch_tween.tween_property(self, "position", Vector3(0.0, standing_height, 0.0), duration)
