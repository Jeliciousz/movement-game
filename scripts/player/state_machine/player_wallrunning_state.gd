class_name PlayerWallRunningState extends PlayerState


func enter() -> void:
	player.wallrun_timestamp = Time.get_ticks_msec()
	
	player.coyote_walljump_active = true
	
	player.clear_grapple_hook_point()
	
	enter_state_checks()


func state_checks() -> void:
	update_stance()
	
	if player.is_on_floor():
		transition_func.call(&"Grounded")
		return
	
	handle_wallrunning()
	
	var horizontal_velocity: Vector3 = Vector3(player.velocity.x, 0, player.velocity.z)
	
	if horizontal_velocity.length() < player.wallrun_stop_speed or horizontal_velocity.dot(player.wallrun_run_direction) <= 0:
		transition_func.call(&"Airborne")
		return
	
	enter_state_checks()


func update(delta: float) -> void:
	var air_resistence: float = player.physics_air_resistence * player.wallrun_air_resistence_multiplier
	var friction: float = player.physics_friction * player.wallrun_friction_multiplier
	var gravity: float = player.physics_gravity * player.wallrun_gravity_multiplier
	
	player.add_air_resistence(delta, air_resistence)
	
	if Time.get_ticks_msec() - player.wallrun_timestamp > player.wallrun_duration:
		player.add_friction(delta, friction, player.wallrun_top_speed)
		player.add_gravity(delta, gravity)
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.wallrun_vertical_friction * delta)
		
		player.add_wallrun_movement(delta)


func update_stance() -> void:
	match player.active_stance:
		player.Stances.Standing:
			player.switch_stance(player.Stances.Sprinting)
		
		player.Stances.Crouching:
			if player.attempt_uncrouch():
				player.switch_stance(player.Stances.Sprinting)


func handle_wallrunning() -> void:
	var wall_normal: Vector3
	
	if not player.is_on_wall():
		var test = player.move_and_collide(-player.wallrun_wall_normal * 0.1, true)
		
		if not (test and test.get_collider().is_in_group("WallrunBodies")):
			transition_func.call(&"Airborne")
			return
		
		player.move_and_collide(-player.wallrun_wall_normal * 0.1)
		
		wall_normal = Vector3(test.get_normal().x, 0, test.get_normal().z).normalized()
	else:
		if not player.get_last_slide_collision().get_collider().is_in_group("WallrunBodies"):
			transition_func.call(&"Airborne")
			return
		
		wall_normal = player.get_wall_normal()
	
	if wall_normal != player.wallrun_wall_normal:
		player.wallrun_wall_normal = Vector3(wall_normal.x, 0, wall_normal.z).normalized()
		
		player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
		
		if player.wallrun_run_direction.dot(Vector3(player.velocity.x, 0, player.velocity.z).normalized()) < 0:
			player.wallrun_run_direction *= -1
		
		var horizontal_colliding_speed = Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length()
		
		player.velocity.x = player.wallrun_run_direction.x * horizontal_colliding_speed
		player.velocity.y = player.colliding_velocity.y
		player.velocity.z = player.wallrun_run_direction.z * horizontal_colliding_speed


func enter_state_checks() -> void:
	if player.walljump_enabled and InputBuffer.is_action_buffered("jump"):
		player.wall_jump()
		
		player.coyote_walljump_active = false
		transition_func.call(&"Jumping")
		return
