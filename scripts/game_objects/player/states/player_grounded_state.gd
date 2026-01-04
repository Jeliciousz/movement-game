class_name PlayerGroundedState
extends State
## Active while the [Player] is on the ground.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.coyote_jump_ready = true
	_player.coyote_slide_ready = true
	_player.airjumps = 0
	_player.aircrouches = 0
	_player.walljumps = 0
	_player.clear_grapplehook_point()


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.can_slide():
		InputBuffer.clear_buffered_action(&"slide")
		_player.coyote_slide_ready = false
		_player.coyote_jump_ready = false
		_player.slide()
		state_machine.change_state_to(&"Sliding")
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.jump_enabled:
		if _player.stance != Player.Stances.CROUCHING:
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_slide_ready = false
			_player.coyote_jump_ready = false
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return

		elif _player.can_crouchjump():
			InputBuffer.clear_buffered_action(&"jump")
			_player.coyote_slide_ready = false
			_player.coyote_jump_ready = false
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.stair_step_up()
	_player.move()

	if not _player.is_on_floor():
		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.change_stance(Player.Stances.SPRINTING)
				return

			if Input.is_action_just_pressed(&"crouch") and _player.crouch_enabled:
				_player.crouch()

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") or not _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.change_stance(Player.Stances.STANDING)
				return

			if Input.is_action_just_pressed(&"crouch") and _player.crouch_enabled:
				_player.crouch()


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

	_player.add_air_resistence()
	_player.add_friction(_player.physics_friction, top_speed)
	_player.add_movement(top_speed, acceleration)
