class_name PlayerWallRunningState
extends State
## Active while the [Player] is wall-running.

## The [Player].
@export var _player: Player

var player_velocity_before_move: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	_player.wall_run_timestamp = Global.time
	_player.coyote_jump_ready = false
	_player.coyote_slide_ready = false
	_player.coyote_wall_jump_ready = true
	_player.air_jumps = 0
	_player.air_crouches = 0
	clear_grapple_hook_point()
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
	player_velocity_before_move = _player.velocity
	_player.move()

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
		return

	var horizontal_velocity: Vector3 = Vector3(_player.velocity.x, 0.0, _player.velocity.z)

	if horizontal_velocity.length() < _player.wall_run_stop_speed or horizontal_velocity.dot(_player.wall_run_direction) <= 0.0 or not wallrun_checks():
		_player.velocity += _player.wall_run_normal * _player.wall_run_cancel_impulse
		state_machine.change_state_to(&"Airborne")
		return


func clear_grapple_hook_point() -> void:
	if _player.active_grapple_hook_point != null:
		_player.active_grapple_hook_point.targeted = GrappleHookPoint.Target.NOT_TARGETED
		_player.active_grapple_hook_point = null


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


func wallrun_checks() -> bool:
	_player.wallrun_floor_raycast.force_raycast_update()

	if _player.wallrun_floor_raycast.is_colliding():
		return false

	var wall_normal: Vector3

	if not _player.is_on_wall():
		_player.wallrun_foot_raycast.target_position = _player.basis.inverse() * -_player.wall_run_normal * _player.collision_shape.shape.radius * 3
		_player.wallrun_hand_raycast.target_position = _player.basis.inverse() * -_player.wall_run_normal * _player.collision_shape.shape.radius * 3
		_player.wallrun_foot_raycast.force_raycast_update()
		_player.wallrun_hand_raycast.force_raycast_update()

		if not (_player.wallrun_foot_raycast.is_colliding() and _player.wallrun_hand_raycast.is_colliding()):
			return false

		wall_normal = Vector3(_player.wallrun_foot_raycast.get_collision_normal().x, 0.0, _player.wallrun_foot_raycast.get_collision_normal().z).normalized()

		if wall_normal.angle_to(_player.wall_run_normal) > _player.wall_run_max_external_angle + deg_to_rad(1):
			return false

		_player.move_and_collide(-_player.wall_run_normal * _player.floor_snap_length, false, _player.safe_margin)

		_player.check_surface(-_player.wall_run_normal)
	else:
		wall_normal = Vector3(_player.get_wall_normal().x, 0.0, _player.get_wall_normal().z).normalized()

		if wall_normal.angle_to(_player.wall_run_normal) > _player.wall_run_max_internal_angle + deg_to_rad(1):
			return false

	if wall_normal != _player.wall_run_normal:
		_player.wall_run_normal = Vector3(wall_normal.x, 0.0, wall_normal.z).normalized()

		_player.wall_run_direction = _player.wall_run_normal.rotated(Vector3.UP, deg_to_rad(90.0))

		if _player.wall_run_direction.dot(Vector3(_player.velocity.x, 0.0, _player.velocity.z).normalized()) < 0.0:
			_player.wall_run_direction *= -1.0

		var horizontal_colliding_speed: float = Vector2(player_velocity_before_move.x, player_velocity_before_move.z).length()

		_player.velocity.x = _player.wall_run_direction.x * horizontal_colliding_speed
		_player.velocity.y = player_velocity_before_move.y
		_player.velocity.z = _player.wall_run_direction.z * horizontal_colliding_speed

	return true
