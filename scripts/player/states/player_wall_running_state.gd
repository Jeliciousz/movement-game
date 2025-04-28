class_name PlayerWallRunningState
extends State
## Active while the [Player] is wall-running.

## The [Player].
@export var _player: Player

var player_velocity_before_move: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	shared_vars[&"wallrun_timestamp"] = Time.get_ticks_msec()
	shared_vars[&"coyote_jump_active"] = false
	shared_vars[&"coyote_slide_active"] = false
	shared_vars[&"coyote_walljump_active"] = true
	shared_vars[&"air_jumps"] = 0
	shared_vars[&"air_crouches"] = 0
	clear_grapple_hook_point()
	_player.footstep_audio.play()


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"jump") and _player.walljump_enabled:
		InputBuffer.clear_buffered_action(&"jump")
		_player.wall_jump(shared_vars[&"wallrun_wall_normal"], shared_vars[&"wallrun_run_direction"])
		shared_vars[&"coyote_walljump_active"] = false
		state_machine.change_state_to(&"Jumping")
		return


func _state_physics_process(delta: float) -> void:
	update_stance()
	update_physics(delta)
	player_velocity_before_move = _player.velocity
	_player.update()

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
		return

	var horizontal_velocity: Vector3 = Vector3(_player.velocity.x, 0.0, _player.velocity.z)

	if horizontal_velocity.length() < _player.wallrun_stop_speed or horizontal_velocity.dot(shared_vars[&"wallrun_run_direction"]) <= 0.0 or not wallrun_checks():
		state_machine.change_state_to(&"Airborne")
		return


func clear_grapple_hook_point() -> void:
	if shared_vars[&"grapple_hook_point"] != null:
		shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
		shared_vars[&"grapple_hook_point"] = null


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING


func update_physics(delta: float) -> void:
	_player.add_air_resistence(_player.physics_air_resistence * _player.wallrun_air_resistence_multiplier)

	if Time.get_ticks_msec() - shared_vars[&"wallrun_timestamp"] > _player.wallrun_duration:
		_player.add_friction(_player.physics_friction * _player.wallrun_friction_multiplier, _player.wallrun_top_speed)
		_player.add_gravity(_player.physics_gravity * _player.wallrun_gravity_multiplier)
	else:
		_player.velocity.y = move_toward(_player.velocity.y, 0, _player.wallrun_vertical_friction * delta)

		_player.add_wallrun_movement(shared_vars[&"wallrun_run_direction"])


func wallrun_checks() -> bool:
	var wall_normal: Vector3

	if not _player.is_on_wall():
		var test: KinematicCollision3D = _player.move_and_collide(-shared_vars[&"wallrun_wall_normal"] * _player.floor_snap_length, true, _player.safe_margin)

		if not (test and test.get_collider().is_in_group("WallrunBodies")):
			return false

		_player.move_and_collide(-shared_vars[&"wallrun_wall_normal"] * _player.floor_snap_length, false, _player.safe_margin)

		_player.check_surface(-shared_vars[&"wallrun_wall_normal"])

		wall_normal = Vector3(test.get_normal().x, 0.0, test.get_normal().z).normalized()
	else:
		if not _player.get_last_slide_collision().get_collider().is_in_group("WallrunBodies"):
			return false

		wall_normal = _player.get_wall_normal()

	if wall_normal != shared_vars[&"wallrun_wall_normal"]:
		shared_vars[&"wallrun_wall_normal"] = Vector3(wall_normal.x, 0.0, wall_normal.z).normalized()

		shared_vars[&"wallrun_run_direction"] = shared_vars[&"wallrun_wall_normal"].rotated(Vector3.UP, deg_to_rad(90.0))

		if shared_vars[&"wallrun_run_direction"].dot(Vector3(_player.velocity.x, 0.0, _player.velocity.z).normalized()) < 0.0:
			shared_vars[&"wallrun_run_direction"] *= -1.0

		var horizontal_colliding_speed: float = Vector2(player_velocity_before_move.x, player_velocity_before_move.z).length()

		_player.velocity.x = shared_vars[&"wallrun_run_direction"].x * horizontal_colliding_speed
		_player.velocity.y = player_velocity_before_move.y
		_player.velocity.z = shared_vars[&"wallrun_run_direction"].z * horizontal_colliding_speed

	return true
