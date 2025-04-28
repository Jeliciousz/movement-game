class_name PlayerGroundedState
extends State
## Active while the [Player] is on the ground.

## The [Player].
@export var _player: Player


func _state_enter() -> void:
	shared_vars[&"coyote_jump_active"] = true
	shared_vars[&"coyote_slide_active"] = true
	shared_vars[&"coyote_walljump_active"] = false
	shared_vars[&"air_jumps"] = 0
	shared_vars[&"air_crouches"] = 0
	clear_grapple_hook_point()


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.slide_enabled and slide_checks():
		InputBuffer.clear_buffered_action(&"slide")
		_player.slide()
		state_machine.change_state_to(&"Sliding")
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.jump_enabled:
		if _player.stance != Player.Stances.CROUCHING:
			InputBuffer.clear_buffered_action(&"jump")
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return

		elif _player.crouch_jump_enabled and (_player.crouch_jump_window == 0.0 or Time.get_ticks_msec() - _player._crouch_timestamp <= _player.crouch_jump_window):
			InputBuffer.clear_buffered_action(&"jump")
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.update()

	if not _player.is_on_floor():
		state_machine.change_state_to(&"Airborne")
		return


func clear_grapple_hook_point() -> void:
	if shared_vars[&"grapple_hook_point"] != null:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
		shared_vars[&"grapple_hook_point"] = null


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.SPRINTING
				return

			if InputBuffer.is_action_buffered(&"crouch") and _player.crouch_enabled:
				InputBuffer.clear_buffered_action(&"crouch")
				_player.crouch()

		Player.Stances.CROUCHING:
			if Input.is_action_just_released(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") or not _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if InputBuffer.is_action_buffered(&"crouch") and _player.crouch_enabled:
				InputBuffer.clear_buffered_action(&"crouch")
				_player.crouch()


func slide_checks() -> bool:
	if _player.get_wish_direction().is_zero_approx():
		return false

	if not is_zero_approx(_player.get_amount_moving_backwards()):
		return false

	if _player.velocity.length() < _player.slide_start_speed:
		return false

	if Time.get_ticks_msec() - shared_vars[&"slide_timestamp"] < _player.slide_cooldown:
		return false

	return true


func update_physics() -> void:
	var top_speed: float
	var acceleration: float

	match _player.stance:
		Player.Stances.STANDING:
			top_speed = _player.move_speed
			acceleration = _player.move_acceleration
		Player.Stances.CROUCHING:
			top_speed = _player.crouch_speed
			acceleration = _player.crouch_acceleration
		Player.Stances.SPRINTING:
			top_speed = _player.sprint_speed
			acceleration = _player.sprint_acceleration

	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_friction(_player.physics_friction, top_speed)
	_player.add_movement(top_speed, acceleration)
