class_name PlayerSlidingState
extends State
## Active while the [Player] is sliding.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.floor_constant_speed = false
	_player.slide_timestamp = Global.time
	_player.coyote_slide_ready = false
	_player.coyote_jump_ready = false

	if _player.ledgejump_enabled:
		_player.ledgejump_ready = true
	elif _player.slidejump_enabled:
		_player.coyote_slidejump_ready = true

	_player.slide_audio.play()


func _state_exit() -> void:
	_player.floor_constant_speed = true
	_player.slide_timestamp = Global.time


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.can_slidejump():
		InputBuffer.clear_buffered_action(&"jump")
		_player.coyote_slidejump_ready = false
		_player.ledgejump_ready = false
		_player.slidejump()
		state_machine.change_state_to(&"Jumping")
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.can_slidecancel():
		InputBuffer.clear_buffered_action(&"slide")
		_player.slidecancel()
		state_machine.change_state_to(&"Grounded")
		return


func _state_physics_process(_delta: float) -> void:
	update_physics()
	_player.move()

	if not _player.is_on_floor():
		state_machine.change_state_to(&"Airborne")
		return

	if not _player.can_continue_sliding():
		_player.attempt_uncrouch()
		state_machine.change_state_to(&"Grounded")
		return


func update_physics() -> void:
	_player.slide_down_slopes()
	_player.add_air_resistence()
	_player.add_friction(_player.physics_friction * _player.slide_friction_multiplier, 0)
	_player.add_movement(0, _player.slide_acceleration)
