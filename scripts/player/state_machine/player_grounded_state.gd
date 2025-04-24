class_name PlayerGroundedState extends PlayerState


func enter() -> void:
	player.coyote_jump_active = true
	player.coyote_slide_active = true
	player.coyote_walljump_active = false
	
	player.air_jumps = 0
	player.air_crouches = 0
	
	player.clear_grapple_hook_point()
	
	player.footsteps_audio.play()
	
	enter_state_checks()


func state_checks() -> void:
	update_stance()
	
	if not player.is_on_floor():
		transition_func.call(&"Airborne")
		return
	
	enter_state_checks()


func physics_update(delta: float) -> void:
	var backwards_multiplier: float = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float
	var acceleration: float
	
	match player.active_stance:
		player.Stances.Standing:
			top_speed = player.move_speed
			acceleration = player.move_acceleration
		player.Stances.Crouching:
			top_speed = player.crouch_speed
			acceleration = player.crouch_acceleration
		player.Stances.Sprinting:
			top_speed = player.sprint_speed
			acceleration = player.sprint_acceleration
	
	top_speed *= backwards_multiplier
	acceleration *= backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_friction(delta, player.physics_friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)


func update_stance() -> void:
	match player.active_stance:
		player.Stances.Standing:
			if player.sprint_enabled and Input.is_action_just_pressed("sprint"):
				player.switch_stance(player.Stances.Sprinting)
				return
		
		player.Stances.Crouching:
			if not (player.crouch_enabled and Input.is_action_pressed("crouch")):
				player.attempt_uncrouch()
		
		player.Stances.Sprinting:
			if not player.sprint_enabled or Input.is_action_just_pressed("sprint"):
				player.switch_stance(player.Stances.Standing)
				return
		
		player.Stances.Standing, player.Stances.Sprinting:
			if player.crouch_enabled and Input.is_action_pressed("crouch"):
				player.crouch()


func enter_state_checks() -> void:
	if player.slide_enabled and slide_checks() and InputBuffer.is_action_buffered("slide"):
		player.crouch()
		player.last_stance = player.Stances.Sprinting
		
		player.velocity.y = 0
		player.velocity += player.move_direction * player.slide_power
		
		transition_func.call(&"Sliding")
		return
	
	if player.jump_enabled and InputBuffer.is_action_buffered("jump"):
		if player.active_stance != player.Stances.Crouching:
			player.jump()
			
			transition_func.call(&"Jumping")
			return
		elif player.coyote_enabled and Time.get_ticks_msec() - player.crouch_timestamp <= player.coyote_duration:
			player.jump()
			
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
