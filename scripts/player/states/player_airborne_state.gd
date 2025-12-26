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
	_player.update_active_grapplehook_point()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.can_coyote_slide():
		InputBuffer.clear_buffered_action(&"slide")
		_player.coyote_slide()

	if InputBuffer.is_action_buffered(&"grapplehook") and _player.can_grapplehook():
		InputBuffer.clear_buffered_action(&"grapplehook")
		_player.grapplehook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return

	if InputBuffer.is_action_buffered(&"jump"):
		if _player.can_coyote_walljump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_walljump_ready = false
			_player.coyote_walljump(_player.wall_run_direction)
			state_machine.change_state_to(&"Jumping")
			return

		if _player.can_ledge_jump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.ledge_jump_ready = false
			_player.ledge_jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.can_coyote_slide_jump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_slide_jump_ready = false
			_player.slide_jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.can_coyote_jump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.can_air_jump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.air_jump()
			state_machine.change_state_to(&"Jumping")
			return


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.stair_step_up()
	_player.move()

	if _player.is_on_floor():
		_player.footstep_audio.play()
		state_machine.change_state_to(&"Grounded")
		return

	if _player.can_mantle():
		state_machine.change_state_to(&"Mantling")
		return

	if _player.can_start_wallrun():
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
				_player.air_crouches += 1
				_player.crouch()

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and _player.air_crouches < _player.air_crouch_limit:
				_player.air_crouches += 1
				_player.crouch()


func update_physics() -> void:
	_player.add_air_resistence()
	_player.add_gravity(_player.physics_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
