class_name PlayerGrappleHookingState
extends State
## Active while the [Player] is grapple-hooking.

## The [Player].
@export var _player: Player

var player_velocity_before_move: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
	shared_vars[&"coyote_jump_active"] = false
	shared_vars[&"coyote_slide_active"] = false
	shared_vars[&"coyote_walljump_active"] = false


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"grapple_hook"):
		InputBuffer.clear_buffered_action(&"grapple_hook")
		state_machine.change_state_to(&"Airborne")
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

	if _player.ledge_grab_enabled and ledgegrab_checks() and _player._input_vector.y < -0.2:
		shared_vars[&"ledge_grab_velocity"] = player_velocity_before_move
		state_machine.change_state_to(&"LedgeGrabbing")
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

	DebugDraw3D.draw_line(_player.get_center_of_mass(), shared_vars[&"grapple_hook_point"].position, Color.BLACK)


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.SPRINTING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
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

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
				_player.crouch()
				shared_vars[&"air_crouches"] += 1


func update_physics() -> void:
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_gravity(_player.physics_gravity)
	_player.add_movement(_player.air_speed, _player.air_acceleration)

	var direction_from_grapple: Vector3 = shared_vars[&"grapple_hook_point"].position.direction_to(_player.get_center_of_mass())
	var distance_from_grapple: float = shared_vars[&"grapple_hook_point"].position.distance_to(_player.get_center_of_mass())
	var weight: float = clampf((distance_from_grapple - 5.0) / (_player.grapple_hook_max_distance - _player.standing_height), 0, 1)
	var power: float = lerpf(0, _player.grapple_hook_speed, weight)

	_player.velocity += -direction_from_grapple * maxf(0, _player.velocity.dot(direction_from_grapple))
	_player.velocity += -direction_from_grapple * maxf(0, (power - _player.velocity.dot(-direction_from_grapple)))


func wallrun_checks() -> bool:
	if Time.get_ticks_msec() - shared_vars[&"wallrun_timestamp"] < _player.wallrun_cooldown:
		return false

	if not _player.is_on_wall():
		return false

	if _player.get_wall_normal().y < -_player.safe_margin:
		return false

	var normal: Vector3 = Vector3(_player.get_wall_normal().x, 0.0, _player.get_wall_normal().z).normalized()

	if _player.get_forward_direction().dot(-normal) > 0.9:
		return false

	var run_direction: Vector3 = normal.rotated(Vector3.UP, deg_to_rad(90.0))

	var horizontal_velocity: Vector3 = Vector3(player_velocity_before_move.x, 0.0, player_velocity_before_move.z)

	if run_direction.dot(_player.get_forward_direction()) < 0.0:
		run_direction *= -1.0

	if horizontal_velocity.length() < _player.wallrun_start_speed:
		return false

	_player.wallrun_floor_raycast.force_raycast_update()

	if _player.wallrun_floor_raycast.is_colliding():
		return false

	_player.wallrun_foot_raycast.target_position = _player.basis.inverse() * -normal * _player.collision_shape.shape.radius * 3
	_player.wallrun_hand_raycast.target_position = _player.basis.inverse() * -normal * _player.collision_shape.shape.radius * 3
	_player.wallrun_foot_raycast.force_raycast_update()
	_player.wallrun_hand_raycast.force_raycast_update()

	if not (_player.wallrun_foot_raycast.is_colliding() and _player.wallrun_hand_raycast.is_colliding()):
		return false

	return true


func ledgegrab_checks() -> bool:
	if not _player.is_on_wall():
		return false

	_player.ledge_grab_foot_raycast.force_raycast_update()
	_player.ledge_grab_hand_raycast.force_raycast_update()
	_player.ledge_grab_head_raycast.force_raycast_update()

	if not _player.ledge_grab_foot_raycast.is_colliding():
		return false

	if _player.ledge_grab_hand_raycast.is_colliding():
		return false

	if _player.ledge_grab_head_raycast.is_colliding():
		return false

	return true
