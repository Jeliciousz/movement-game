class_name PlayerSlidingState
extends State
## Active while the [Player] is sliding.

## The [Player].
@export var _player: Player


func _state_enter() -> void:
	_player.floor_constant_speed = false
	shared_vars[&"slide_timestamp"] = Time.get_ticks_msec()
	shared_vars[&"coyote_slide_active"] = false
	_player.slide_audio.play()


func _state_exit() -> void:
	_player.floor_constant_speed = true
	shared_vars[&"slide_timestamp"] = Time.get_ticks_msec()
	_player.velocity -= _player.velocity.normalized() * _player.slide_stop_force


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.slide_jump_enabled and Time.get_ticks_msec() - shared_vars[&"slide_timestamp"] >= _player.slide_jump_delay:
		InputBuffer.clear_buffered_action(&"jump")
		_player.attempt_uncrouch()
		_player.slide_jump()
		state_machine.change_state_to(&"Jumping")
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.slide_cancel_enabled and Time.get_ticks_msec() - shared_vars[&"slide_timestamp"] >= _player.slide_cancel_delay:
		InputBuffer.clear_buffered_action(&"slide")
		state_machine.change_state_to(&"Grounded")
		return


func _state_physics_process(delta: float) -> void:
	update_physics(delta)
	_player.update()

	if not _player.is_on_floor():
		state_machine.change_state_to(&"Airborne")
		return

	if not _player.slide_enabled or Time.get_ticks_msec() - shared_vars[&"slide_timestamp"] > _player.slide_duration or _player.velocity.length() < _player.slide_stop_speed:
		_player.attempt_uncrouch()
		state_machine.change_state_to(&"Grounded")
		return


func update_physics(delta: float) -> void:
	var weight: float = _player.get_floor_normal().dot(_player.velocity.normalized())

	_player.velocity += _player.velocity.normalized() * weight * 15.0 * delta
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_friction(_player.physics_friction * _player.slide_friction_multiplier, 0)
	_player.add_movement(0, _player.slide_acceleration)
