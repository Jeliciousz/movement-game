class_name PlayerAirborne extends State


@export var player: Player


#func wallrun_check() -> bool:
	#if player.horizontal_speed < player.wallrun_start_speed_threshold:
		#return false
	#
	#if not player.is_on_wall():
		#return false
	#
	#if not player.get_last_slide_collision().get_collider().is_in_group("CanWallrun"):
		#return false
	#
	#var wall_normal = player.get_wall_normal()
	#wall_normal.y = 0
	#wall_normal = wall_normal.normalized()
	#
	#if wall_normal.is_equal_approx(player.wallrun_wall_normal):
		#return false
	#
	#var travel: Vector3 = player.get_last_slide_collision().get_travel()
	#travel.y = 0
	#travel = travel.normalized()
	#
	#if travel.angle_to(-wall_normal) < player.wallrun_minimum_angle_threshold:
		#return false
	#
	#player.wallrun_wall_normal = wall_normal
	#player.velocity = player.velocity_direction * player.horizontal_speed * player.wallrun_speed_conversion_multiplier
	#transition.emit(&"PlayerWallrunning")
	#return true


func enter() -> void:
	player.airborne_timestamp = Time.get_ticks_msec()
	
	#if wallrun_check():
	#	return
	
	# Coyote Sliding
	if player.coyote_slide_possible and Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and is_zero_approx(player.get_amount_moving_backwards()) and InputBuffer.is_action_buffered("crouch"):
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
	
	#if wallrun_check():
	#	return
	
	# Coyote Sliding
	if player.coyote_slide_possible and Time.get_ticks_msec() - player.airborne_timestamp <= player.slide_coyote_duration and Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and is_zero_approx(player.get_amount_moving_backwards()) and InputBuffer.is_action_buffered("crouch"):
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
