class_name PlayerAirborne extends State


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
	
	var wall_normal = Vector3(player.get_wall_normal().x, 0, player.get_wall_normal().z).normalized()
	
	if wall_normal.is_equal_approx(player.wallrun_wall_normal):
		return false
	
	if wall_normal.y < 0:
		return false
	
	player.wallrun_wall_normal = wall_normal
	player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
	
	if player.wallrun_run_direction.dot(player.get_look_direction()) < 0:
		player.wallrun_run_direction *= -1
	
	player.velocity = player.velocity.normalized() * horizontal_speed * player.wallrun_speed_conversion_multiplier
	
	return true


func enter() -> void:
	player.airborne_timestamp = Time.get_ticks_msec()
	
	if wallrun_check():
		transition.emit(&"PlayerWallrunning")
		return
	
	var speed = player.velocity.length()
	
	# Coyote Sliding
	if player.coyote_slide_possible and Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and player.is_sprinting and not player.move_direction.is_zero_approx() and is_zero_approx(player.get_amount_moving_backwards()) and speed >= player.slide_start_speed_threshold and InputBuffer.is_action_buffered("crouch"):
		player.velocity.y = 0
		player.add_velocity(player.slide_power, player.move_direction)
		transition.emit(&"PlayerSliding")
		return
	
	# Coyote Jumping
	if player.coyote_jump_possible and InputBuffer.is_action_buffered("jump"):
		player.velocity.y = 0
		player.jump()
		transition.emit(&"PlayerJumping")
		return
	
	# Air Jumping
	if player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		transition.emit(&"PlayerJumping")
		return
	
	# Air Dashing
	if player.air_dashes < player.air_dash_limit and Input.is_action_just_pressed("sprint"):
		transition.emit(&"PlayerAirdashing")
		return


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if wallrun_check():
		transition.emit(&"PlayerWallrunning")
		return
	
	var speed = player.velocity.length()
	
	# Coyote Sliding
	if player.coyote_slide_possible and Time.get_ticks_msec() - player.airborne_timestamp <= player.slide_coyote_duration and Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and is_zero_approx(player.get_amount_moving_backwards()) and player.is_sprinting and not player.move_direction.is_zero_approx() and is_zero_approx(player.get_amount_moving_backwards()) and speed >= player.slide_start_speed_threshold and InputBuffer.is_action_buffered("crouch"):
		player.velocity.y = 0
		player.add_velocity(player.slide_power, player.move_direction)
		transition.emit(&"PlayerSliding")
		return
	
	# Coyote Jumping
	if player.coyote_jump_possible and Time.get_ticks_msec() - player.airborne_timestamp <= player.jump_coyote_duration and InputBuffer.is_action_buffered("jump"):
		player.velocity.y = 0
		player.jump()
		transition.emit(&"PlayerJumping")
		return
	
	# Air Jumping
	if player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		transition.emit(&"PlayerJumping")
		return
	
	# Air Dashing
	if player.air_dashes < player.air_dash_limit and Input.is_action_just_pressed("sprint"):
		transition.emit(&"PlayerAirdashing")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, player.physics_gravity)
	player.add_movement(delta, top_speed, acceleration)
