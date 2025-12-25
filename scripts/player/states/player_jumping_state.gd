class_name PlayerJumpingState
extends State
## Active while the [Player] is jumping.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.jump_timestamp = Global.time
	_player.coyote_jump_ready = false
	_player.coyote_slide_ready = false
	_player.footstep_audio.play()


func _state_physics_preprocess(_delta: float) -> void:
	handle_grapple_hooking()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"grapple_hook") and _player.grapple_hook_point_in_range:
		InputBuffer.clear_buffered_action(&"grapple_hook")
		_player.grapple_hook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return

	if not Input.is_action_pressed(&"jump"):
		state_machine.change_state_to(&"Airborne")
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

	if not _player.jump_enabled or _player.velocity.y < 0.0 or Global.time - _player.jump_timestamp >= _player.jump_duration:
		state_machine.change_state_to(&"Airborne")
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
	_player.add_gravity(_player.physics_gravity_multiplier * _player.jump_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
