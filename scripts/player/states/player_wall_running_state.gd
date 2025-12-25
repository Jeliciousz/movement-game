class_name PlayerWallRunningState
extends State
## Active while the [Player] is wall-running.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.wall_run_timestamp = Global.time
	_player.coyote_jump_ready = false
	_player.coyote_slide_ready = false
	_player.coyote_wall_jump_ready = true
	_player.air_jumps = 0
	_player.air_crouches = 0
	_player.clear_grapple_hook_point()
	_player.footstep_audio.play()


func _state_exit() -> void:
	_player.wall_run_timestamp = Global.time


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump"):
		InputBuffer.clear_buffered_action(&"jump")

		_player.wall_jump(_player.wall_run_normal, _player.wall_run_direction)
		_player.coyote_wall_jump_ready = false
		state_machine.change_state_to(&"Jumping")
		return

	if InputBuffer.is_action_buffered(&"crouch"):
		InputBuffer.clear_buffered_action(&"crouch")
		_player.coyote_wall_jump_ready = false
		_player.velocity += _player.wall_run_normal * _player.wall_run_cancel_impulse
		state_machine.change_state_to(&"Airborne")


func _state_physics_process(delta: float) -> void:
	update_stance()
	update_physics(delta)
	_player.stair_step_up(_player.get_horizontal_velocity() * delta)
	_player.move()

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
		return

	if _player.get_horizontal_speed() < _player.wall_run_stop_speed or _player.get_horizontal_velocity().dot(_player.wall_run_direction) <= 0.0 or not _player.can_continue_wallrun():
		_player.velocity += _player.wall_run_normal * _player.wall_run_cancel_impulse
		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING


func update_physics(delta: float) -> void:
	if Global.time - _player.wall_run_timestamp > _player.wall_run_duration:
		_player.add_air_resistence(_player.physics_air_resistence)
		_player.add_friction(_player.physics_friction * _player.wall_run_friction_multiplier, _player.wall_run_speed)
		_player.add_gravity(_player.physics_gravity_multiplier * _player.wall_run_gravity_multiplier)
	else:
		_player.add_air_resistence(_player.physics_air_resistence * _player.wall_run_air_resistence_multiplier)

		if _player.velocity.y < 0:
			_player.velocity = _player.velocity.move_toward(_player.get_horizontal_velocity(), _player.wall_run_downwards_friction * delta)
		else:
			_player.velocity = _player.velocity.move_toward(_player.get_horizontal_velocity(), _player.wall_run_upwards_friction * delta)

		_player.add_wallrun_movement(_player.wall_run_direction)
