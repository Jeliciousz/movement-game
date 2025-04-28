class_name PlayerAirborneState
extends State
## Active while the [Player] is in the air.

## The [Player].
@export var _player: Player

var player_velocity_before_move: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	shared_vars[&"airborne_timestamp"] = Time.get_ticks_msec()
	player_velocity_before_move = Vector3.ZERO


func _state_physics_preprocess(_delta: float) -> void:
	handle_grapple_hooking()

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"slide") and _player.slide_enabled and _player.coyote_slide_enabled and shared_vars[&"coyote_slide_active"] and Time.get_ticks_msec() - shared_vars[&"airborne_timestamp"] <= _player.coyote_duration and slide_checks():
		InputBuffer.clear_buffered_action(&"slide")
		_player.slide()

	if InputBuffer.is_action_buffered(&"jump"):
		if _player.walljump_enabled and _player.coyote_walljump_enabled and shared_vars[&"coyote_walljump_active"] and Time.get_ticks_msec() - shared_vars[&"airborne_timestamp"] <= _player.coyote_duration:
			InputBuffer.clear_buffered_action(&"jump")
			_player.wall_jump(shared_vars[&"wallrun_wall_normal"], shared_vars[&"wallrun_run_direction"])
			shared_vars[&"coyote_walljump_active"] = false
			state_machine.change_state_to(&"Jumping")
			return

		if _player.jump_enabled and _player.coyote_jump_enabled and shared_vars[&"coyote_jump_active"] and Time.get_ticks_msec() - shared_vars[&"airborne_timestamp"] <= _player.coyote_duration:
			InputBuffer.clear_buffered_action(&"jump")
			_player.velocity -= _player.up_direction * _player.velocity.dot(_player.up_direction)
			_player.jump()
			state_machine.change_state_to(&"Jumping")
			return

		if _player.air_jump_enabled and shared_vars[&"air_jumps"] < _player.air_jump_limit:
			InputBuffer.clear_buffered_action(&"jump")
			_player.air_jump()
			shared_vars[&"air_jumps"] += 1
			state_machine.change_state_to(&"Jumping")
			return

	if InputBuffer.is_action_buffered(&"grapple_hook") and shared_vars[&"grapple_hook_point"] != null and shared_vars[&"grapple_hook_point_in_range"]:
		InputBuffer.clear_buffered_action(&"grapple_hook")
		_player.grapple_hook_fire_audio.play()
		state_machine.change_state_to(&"GrappleHooking")
		return


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	player_velocity_before_move = _player.velocity
	_player.update()

	if _player.is_on_floor():
		_player.footstep_audio.play()
		state_machine.change_state_to(&"Grounded")
		return

	if _player.wallrun_enabled and wallrun_checks():
		shared_vars[&"wallrun_wall_normal"] = Vector3(_player.get_wall_normal().x, 0.0, _player.get_wall_normal().z).normalized()
		shared_vars[&"wallrun_run_direction"] = shared_vars[&"wallrun_wall_normal"].rotated(Vector3.UP, deg_to_rad(90.0))

		if shared_vars[&"wallrun_run_direction"].dot(_player.get_forward_direction()) < 0.0:
			shared_vars[&"wallrun_run_direction"] *= -1.0

		var new_velocity: Vector3 = shared_vars[&"wallrun_run_direction"] * Vector2(player_velocity_before_move.x, player_velocity_before_move.z).length()
		_player.velocity.x = new_velocity.x
		_player.velocity.z = new_velocity.z
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

			if InputBuffer.is_action_buffered(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
				InputBuffer.clear_buffered_action(&"crouch")
				_player.crouch()
				shared_vars[&"air_crouches"] += 1

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if InputBuffer.is_action_buffered(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
				InputBuffer.clear_buffered_action(&"crouch")
				_player.crouch()
				shared_vars[&"air_crouches"] += 1


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

	shared_vars[&"grapple_hook_point_in_range"] = shared_vars[&"grapple_hook_point"].position.distance_to(_player.head.global_position) <= _player.grapple_hook_max_distance

	if not shared_vars[&"grapple_hook_point_in_range"]:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.INVALID_TARGET
	elif shared_vars[&"grapple_hook_point"].targeted != GrappleHookPoint.Target.TARGETED:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.TARGETED
		_player.grapple_hook_indicator_audio.play()


func clear_grapple_hook_point() -> void:
	if shared_vars[&"grapple_hook_point"] != null:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
		shared_vars[&"grapple_hook_point"] = null


func slide_checks() -> bool:
	if _player.get_wish_direction().is_zero_approx():
		return false

	if not is_zero_approx(_player.get_amount_moving_backwards()):
		return false

	if _player.velocity.length() < _player.slide_start_speed:
		return false

	if Time.get_ticks_msec() - shared_vars[&"slide_timestamp"] < _player.slide_cooldown:
		return false

	return true


func update_physics() -> void:
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_gravity(_player.physics_gravity)
	_player.add_movement(_player.air_speed, _player.air_acceleration)


func wallrun_checks() -> bool:
	if Time.get_ticks_msec() - shared_vars[&"wallrun_timestamp"] < _player.wallrun_cooldown:
		return false

	if not _player.is_on_wall():
		return false

	if _player.get_wall_normal().y < -_player.safe_margin:
		return false

	if not _player.get_last_slide_collision().get_collider().is_in_group(&"WallrunBodies"):
		return false

	if Vector2(player_velocity_before_move.x, player_velocity_before_move.z).length() < _player.wallrun_start_speed:
		return false

	return true
