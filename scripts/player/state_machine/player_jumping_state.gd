class_name PlayerJumpingState extends PlayerState


func enter() -> void:
	player.jump_timestamp = Time.get_ticks_msec()
	
	player.coyote_jump_active = false
	player.coyote_slide_active = false
	
	player.clear_grapple_hook_point()
	
	player.footsteps_audio.play()
	
	enter_state_checks()


func exit() -> void:
	player.jump_timestamp = Time.get_ticks_msec()


func state_checks() -> void:
	update_stance()
	
	if player.is_on_floor():
		transition_func.call(&"Grounded")
		return
	
	enter_state_checks()


func update(delta: float) -> void:
	var backwards_multiplier: float = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	var gravity: float = player.physics_gravity * player.jump_gravity_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, gravity)
	player.add_movement(delta, top_speed, acceleration)


func update_stance() -> void:
	match player.active_stance:
		player.Stances.Crouching:
			if not (player.crouch_enabled and Input.is_action_pressed("crouch")):
				player.attempt_uncrouch()
		
		player.Stances.Standing, player.Stances.Sprinting:
			if player.air_crouch_enabled and player.air_crouches < player.air_crouch_limit and Input.is_action_pressed("crouch"):
				player.crouch()
				player.air_crouches += 1


func enter_state_checks() -> void:
	if not player.jump_enabled or not Input.is_action_pressed("jump") or player.velocity.y < 0 or Time.get_ticks_msec() - player.jump_timestamp >= player.jump_duration:
		transition_func.call(&"Airborne")
		return
