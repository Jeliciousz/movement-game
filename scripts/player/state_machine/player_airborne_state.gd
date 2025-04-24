class_name PlayerAirborneState extends PlayerState


func enter() -> void:
	player.airborne_timestamp = Time.get_ticks_msec()
	
	enter_state_checks()


func state_checks() -> void:
	update_stance()
	
	if player.is_on_floor():
		transition_func.call(&"Grounded")
		return
	
	if handle_grapple_hooking():
		return
	
	enter_state_checks()


func physics_update(delta: float) -> void:
	var backwards_multiplier: float = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, player.physics_gravity)
	player.add_movement(delta, top_speed, acceleration)


func update_stance() -> void:
	match player.active_stance:
		player.Stances.STANDING, player.Stances.SPRINTING:
			if player.air_crouch_enabled and player.air_crouches < player.air_crouch_limit and Input.is_action_pressed("crouch"):
				player.crouch()
				player.air_crouches += 1
		
		player.Stances.CROUCHING:
			if not (player.crouch_enabled and Input.is_action_pressed("crouch")):
				player.attempt_uncrouch()


func enter_state_checks() -> void:
	if player.wallrun_enabled and wallrun_checks():
		player.wallrun_wall_normal = Vector3(player.get_wall_normal().x, 0, player.get_wall_normal().z).normalized()
		player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
		
		if player.wallrun_run_direction.dot(player.get_forward_direction()) < 0:
			player.wallrun_run_direction *= -1
		
		var new_velocity: Vector3 = player.wallrun_run_direction * Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length()
		
		player.velocity.x = new_velocity.x
		player.velocity.z = new_velocity.z
		
		transition_func.call(&"WallRunning")
		return
	
	if player.coyote_enabled and Time.get_ticks_msec() - player.airborne_timestamp <= player.coyote_duration:
		if player.slide_enabled and player.coyote_slide_active and slide_checks() and InputBuffer.is_action_buffered("slide"):
			player.crouch()
			player.last_stance = player.Stances.SPRINTING
			
			player.velocity.y = 0
			player.velocity += player.move_direction * player.slide_power
			
			transition_func.call(&"Sliding")
			return
		
		if player.walljump_enabled and player.coyote_walljump_active and InputBuffer.is_action_buffered("jump"):
			player.wall_jump()
			
			player.coyote_walljump_active = false
			transition_func.call(&"Jumping")
			return
		
		if player.jump_enabled and player.coyote_jump_active and InputBuffer.is_action_buffered("jump"):
			player.velocity.y = 0
			player.jump()
			
			transition_func.call(&"Jumping")
			return
	
	if player.air_jump_enabled and player.air_jumps < player.air_jump_limit and InputBuffer.is_action_buffered("jump"):
		player.air_jump()
		
		transition_func.call(&"Jumping")
		return


func slide_checks() -> bool:
	if player.move_direction.is_zero_approx():
		return false
	
	if not is_zero_approx(player.get_amount_moving_backwards()):
		return false
	
	if player.velocity.length() < player.slide_start_speed:
		return false
	
	if Time.get_ticks_msec() - player.slide_timestamp < player.slide_cooldown:
		return false
	
	return true


func wallrun_checks() -> bool:
	if Time.get_ticks_msec() - player.wallrun_timestamp < player.wallrun_cooldown:
		return false
	
	if not player.is_on_wall():
		return false
	
	if player.get_wall_normal().y < 0:
		return false
	
	if not player.get_last_slide_collision().get_collider().is_in_group("WallrunBodies"):
		return false
	
	if Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length() < player.wallrun_start_speed:
		return false
	
	return true


func handle_grapple_hooking() -> bool:
	if not player.grapple_hook_enabled:
		player.clear_grapple_hook_point()
		return false
	
	var target_grapple_hook_point: GrappleHookPoint = player.get_targeted_grapple_hook_point()
	
	if not target_grapple_hook_point:
		player.clear_grapple_hook_point()
		return false
	elif player.grapple_hook_point != target_grapple_hook_point:
		player.clear_grapple_hook_point()
		player.grapple_hook_point = target_grapple_hook_point
	
	if player.grapple_hook_point.position.distance_to(player.head.global_position) > player.grapple_hook_max_distance:
		player.grapple_hook_point.targeted = player.grapple_hook_point.InvalidTarget
		return false
	
	if player.grapple_hook_point.targeted != player.grapple_hook_point.Targeted:
		player.grapple_hook_point.targeted = player.grapple_hook_point.Targeted
		
		player.grapple_hook_indicator_audio.play()
	
	if Input.is_action_just_pressed("grapple_hook"):
		player.grapple_hook_fire_audio.play()
		
		transition_func.call(&"GrappleHooking")
		
		return true
	
	return false
