class_name PlayerAirborneState
extends State
## Active while the [Player] is in the air.

## The [Player].
@export var _player: Player


func _state_enter(last_state_name: StringName) -> void:
	if last_state_name == &"Grounded" and _player.stair_step_down():
		state_machine.change_state_to(&"Grounded")
		return

	_player.coyote_engine_timestamp = Time.get_ticks_msec()
	_player.airborne_timestamp = Global.time


func _state_physics_preprocess(_delta: float) -> void:
	handle_grapple_hooking()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.coyote_slide_enabled and _player.coyote_slide_ready and Time.get_ticks_msec() - _player.coyote_engine_timestamp <= _player.coyote_duration and _player.can_slide():
		InputBuffer.clear_buffered_action(&"slide")
		_player.slide()
		_player.attempt_uncrouch()

	if InputBuffer.is_action_buffered(&"grapple_hook") and _player.active_grapple_hook_point != null and _player.grapple_hook_point_in_range:
		InputBuffer.clear_buffered_action(&"grapple_hook")
		_player.grapple_hook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return

	if InputBuffer.is_action_buffered(&"jump"):
		if _player.wall_run_enabled and _player.coyote_walljump_enabled and _player.coyote_wall_jump_ready and Time.get_ticks_msec() - _player.coyote_engine_timestamp <= _player.coyote_duration:
			InputBuffer.clear_buffered_action(&"jump")

			_player.velocity -= _player.wall_run_normal * _player.wall_run_cancel_impulse
			_player.wall_jump(_player.wall_run_normal, _player.wall_run_direction)
			_player.coyote_wall_jump_ready = false
			state_machine.change_state_to(&"Jumping")
			return

		if _player.ledge_jump_enabled and _player.ledge_jump_ready and _player.slide_timestamp == _player.airborne_timestamp and Global.time - _player.airborne_timestamp <= _player.ledge_jump_window:
			InputBuffer.clear_buffered_action(&"jump")
			_player.ledge_jump_ready = false
			_player.velocity.y = 0.0
			_player.ledge_jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.slide_jump_enabled and _player.coyote_slide_jump_enabled and _player.coyote_slide_jump_ready and Time.get_ticks_msec() - _player.coyote_engine_timestamp <= _player.coyote_duration:
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_slide_jump_ready = false
			_player.slide_jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.jump_enabled and _player.coyote_jump_enabled and _player.coyote_jump_ready and Time.get_ticks_msec() - _player.coyote_engine_timestamp <= _player.coyote_duration:
			InputBuffer.clear_buffered_action(&"jump")
			_player.velocity.y = 0.0
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.air_jump_enabled and _player.air_jumps < _player.air_jump_limit:
			InputBuffer.clear_buffered_action(&"jump")
			_player.air_jump()
			_player.air_jumps += 1
			state_machine.change_state_to(&"Jumping")
			return


func _state_physics_process(delta: float) -> void:
	update_stance()
	update_physics()
	_player.stair_step_up(_player.get_horizontal_velocity() * delta)
	_player.move()

	if _player.is_on_floor():
		_player.footstep_audio.play()
		state_machine.change_state_to(&"Grounded")
		return

	if _player.mantle_enabled and _player.can_start_mantle():
		state_machine.change_state_to(&"Mantling")
		return

	if _player.wall_run_enabled and _player.can_start_wallrun():
		_player.start_wallrun()
		state_machine.change_state_to(&"WallRunning")
		return


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.SPRINTING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and _player.air_crouches < _player.air_crouch_limit:
				_player.crouch()
				_player.air_crouches += 1

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and _player.air_crouches < _player.air_crouch_limit:
				_player.crouch()
				_player.air_crouches += 1


func handle_grapple_hooking() -> void:
	if not _player.grapple_hook_enabled:
		_player.clear_grapple_hook_point()
		return

	var target_grapple_hook_point: GrappleHookPoint = _player.get_targeted_grapple_hook_point()

	if target_grapple_hook_point == null:
		_player.clear_grapple_hook_point()
		return
	elif _player.active_grapple_hook_point != target_grapple_hook_point:
		_player.clear_grapple_hook_point()
		_player.active_grapple_hook_point = target_grapple_hook_point

	_player.grapple_hook_point_in_range = _player.active_grapple_hook_point.position.distance_to(_player.head.global_position) <= _player.grapple_hook_max_distance

	if not _player.grapple_hook_point_in_range:
		_player.active_grapple_hook_point.targeted = GrappleHookPoint.Target.INVALID_TARGET
	elif _player.active_grapple_hook_point.targeted != GrappleHookPoint.Target.TARGETED:
		_player.active_grapple_hook_point.targeted = GrappleHookPoint.Target.TARGETED
		_player.grapple_hook_indicator_audio.play()


func update_physics() -> void:
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_gravity(_player.physics_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
