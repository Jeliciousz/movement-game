class_name PlayerAirdashing extends State


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
	player.air_dash_timestamp = Time.get_ticks_msec()
	player.air_dashes += 1
	
	player.velocity.y = player.air_dash_vertical_power * maxf(1 - player.get_look_direction().dot(Vector3.DOWN), 1)
	player.velocity += player.get_look_direction() * player.air_dash_power
	
	#if wallrun_check():
	#	return
	
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
	
	#if wallrun_check():
	#	return
	
	# Air Jumping
	if player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	var gravity: float = player.physics_gravity * player.air_dash_gravity_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, gravity)
