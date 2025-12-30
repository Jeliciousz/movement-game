class_name PlayerWallGrabbingState
extends State
## Active while the [Player] is wall-grabbing.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.coyote_walljump_ready = true
	_player.airjumps = 0
	_player.aircrouches = 0
	_player.clear_grapplehook_point()
	_player.footstep_audio.play()


func _state_exit() -> void:
	_player.wallgrab_timestamp = Global.time


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.walljump_enabled:
		InputBuffer.clear_buffered_action(&"jump")
		_player.coyote_walljump_ready = false
		_player.walljump()
		state_machine.change_state_to(&"Jumping")
		return

	if InputBuffer.is_action_buffered(&"crouch"):
		InputBuffer.clear_buffered_action(&"crouch")
		_player.coyote_walljump_ready = false
		_player.stop_wallgrab()
		state_machine.change_state_to(&"Airborne")


func _state_physics_process(_delta: float) -> void:
	update_physics()
	_player.move()

	if _player.is_on_floor():
		_player.coyote_walljump_ready = false
		state_machine.change_state_to(&"Grounded")
		return

	if not _player.can_continue_wallgrabbing():
		state_machine.change_state_to(&"Airborne")
		return


func update_physics() -> void:
	_player.add_air_resistence()
	_player.add_friction(_player.physics_friction * _player.wallgrab_friction_multiplier, 0.0)
	_player.add_gravity(_player.physics_gravity_multiplier)
