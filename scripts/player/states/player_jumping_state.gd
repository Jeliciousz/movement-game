class_name PlayerJumpingState
extends State
## Active while the [Player] is jumping.

## The [Player].
@export var _player: Player


func _state_enter() -> void:
	shared_vars[&"jump_timestamp"] = Time.get_ticks_msec()
	shared_vars[&"coyote_jump_active"] = false
	shared_vars[&"coyote_slide_active"] = false
	_player.footstep_audio.play()


func _state_exit() -> void:
	shared_vars[&"jump_timestamp"] = Time.get_ticks_msec()


func _state_physics_preprocess(_delta: float) -> void:
	handle_grapple_hooking()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	update_stance()

	if InputBuffer.is_action_buffered(&"grapple_hook") and shared_vars[&"grapple_hook_point_in_range"]:
		InputBuffer.clear_buffered_action(&"grapple_hook")
		_player.grapple_hook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return

	if not Input.is_action_pressed(&"jump"):
		state_machine.change_state_to(&"Airborne")
		return


func _state_physics_process(_delta: float) -> void:
	update_physics()
	_player.update()

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
		return

	if not _player.jump_enabled or _player.velocity.dot(_player.up_direction) < 0.0 or Time.get_ticks_msec() - shared_vars[&"jump_timestamp"] >= _player.jump_duration:
		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING, Player.Stances.SPRINTING:
			if _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit and Input.is_action_pressed(&"crouch"):
				_player.crouch()
				shared_vars[&"air_crouches"] += 1

		Player.Stances.CROUCHING:
			if not _player.crouch_enabled or not Input.is_action_pressed(&"crouch"):
				_player.attempt_uncrouch()


func handle_grapple_hooking() -> void:
	if not _player.grapple_hook_enabled:
		clear_grapple_hook_point()
		return

	var target_grapple_hook_point: GrappleHookPoint = _player.get_targeted_grapple_hook_point()

	if target_grapple_hook_point == null:
		clear_grapple_hook_point()
		return
	elif shared_vars[&"grapple_hook_point"] != target_grapple_hook_point:
		clear_grapple_hook_point()
		shared_vars[&"grapple_hook_point"] = target_grapple_hook_point

	shared_vars[&"grapple_hook_point_in_range"] = shared_vars[&"grapple_hook_point"].position.distance_to(_player.head.global_position) > _player.grapple_hook_max_distance

	if not shared_vars[&"grapple_hook_point_in_range"]:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.INVALID_TARGET
	elif shared_vars[&"grapple_hook_point"].targeted != GrappleHookPoint.Target.TARGETED:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.TARGETED
		_player.grapple_hook_indicator_audio.play()


func clear_grapple_hook_point() -> void:
	if shared_vars[&"grapple_hook_point"] != null:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
		shared_vars[&"grapple_hook_point"] = null


func update_physics() -> void:
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_gravity(_player.physics_gravity * _player.jump_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
