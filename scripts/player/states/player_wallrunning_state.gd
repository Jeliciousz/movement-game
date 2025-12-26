class_name PlayerWallRunningState
extends State
## Active while the [Player] is wall-running.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.wallrun_timestamp = Global.time
	_player.coyote_walljump_ready = true
	_player.coyote_jump_ready = false
	_player.coyote_slide_ready = false
	_player.air_jumps = 0
	_player.air_crouches = 0
	_player.clear_grapplehook_point()
	_player.footstep_audio.play()


func _state_exit() -> void:
	_player.wallrun_timestamp = Global.time


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.walljump_enabled:
		InputBuffer.clear_buffered_action(&"jump")
		_player.coyote_walljump_ready = false
		_player.walljump(_player.wallrun_direction)
		state_machine.change_state_to(&"Jumping")
		return

	if InputBuffer.is_action_buffered(&"crouch"):
		InputBuffer.clear_buffered_action(&"crouch")
		_player.coyote_walljump_ready = false
		_player.stop_wallrun()
		state_machine.change_state_to(&"Airborne")


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.stair_step_up()
	_player.move()

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
		return

	if not _player.try_stick_to_wallrun():
		_player.stop_wallrun()
		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING


func update_physics() -> void:
	if Global.time - _player.wallrun_timestamp > _player.wallrun_duration:
		_player.add_air_resistence()
		_player.add_friction(_player.physics_friction * _player.wallrun_friction_multiplier, _player.wallrun_speed)
		_player.add_gravity(_player.physics_gravity_multiplier * _player.wallrun_gravity_multiplier)
	else:
		_player.add_air_resistence()
		_player.add_wallrun_friction()
		_player.add_wallrun_movement()
