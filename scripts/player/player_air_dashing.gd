class_name PlayerAirdashing extends State


@export var player: Player


func wallrun_check() -> bool:
	if not player.is_sprinting:
		return false
	
	var horizontal_speed: float = Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length()
	
	if horizontal_speed < player.wallrun_start_speed_threshold:
		return false
	
	if not player.is_on_wall():
		return false
	
	if not player.get_last_slide_collision().get_collider().is_in_group("WallrunBodies"):
		return false
	
	if player.get_wall_normal().y < 0:
		return false
	
	var wall_normal = Vector3(player.get_wall_normal().x, 0, player.get_wall_normal().z).normalized()
	
	if wall_normal.is_equal_approx(player.wallrun_wall_normal):
		return false
	
	player.wallrun_wall_normal = wall_normal
	player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
	
	if player.wallrun_run_direction.dot(player.get_look_direction()) < 0:
		player.wallrun_run_direction *= -1
	
	player.velocity = player.velocity.normalized() * horizontal_speed * player.wallrun_speed_conversion_multiplier
	
	return true


func enter() -> void:
	player.air_dash_timestamp = Time.get_ticks_msec()
	player.air_dashes += 1
	
	player.velocity.y = player.air_dash_vertical_power * maxf(1 - player.get_look_direction().dot(Vector3.DOWN), 1)
	player.velocity += player.get_look_direction() * player.air_dash_power
	
	if wallrun_check():
		transition.emit(&"PlayerWallrunning")
		return
	
	# Air Jumping
	if player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		transition.emit(&"PlayerJumping")
		return


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if Time.get_ticks_msec() - player.air_dash_timestamp > player.air_dash_duration:
		player.velocity = player.velocity.move_toward(Vector3.ZERO, player.air_dash_end_power)
		transition.emit(&"PlayerAirborne")
		return
	
	if wallrun_check():
		transition.emit(&"PlayerWallrunning")
		return
	
	# Air Jumping
	if player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	var gravity: float = player.physics_gravity * player.air_dash_gravity_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, gravity)
