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
	_player.update_active_grapple_hook_point()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"grapple_hook") and _player.can_grapple_hook():
		InputBuffer.clear_buffered_action(&"grapple_hook")
		_player.grapple_hook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return

	if not Input.is_action_pressed(&"jump"):
		state_machine.change_state_to(&"Airborne")
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

	if not _player.can_continue_jumping():
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
	_player.add_gravity(_player.physics_gravity_multiplier * _player.jump_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
