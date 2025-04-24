class_name PlayerSlidingState extends PlayerState


func enter() -> void:
	player.slide_timestamp = Time.get_ticks_msec()
	
	player.coyote_slide_active = false
	
	player.clear_grapple_hook_point()
	
	player.slide_audio.play()
	
	enter_state_checks()


func exit() -> void:
	player.slide_timestamp = Time.get_ticks_msec()


func state_checks() -> void:
	if not player.is_on_floor():
		transition_func.call(&"Airborne")
		return
	
	enter_state_checks()


func physics_update(delta: float) -> void:
	var friction: float = player.physics_friction * player.slide_friction_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_friction(delta, friction, 0)
	player.add_movement(delta, 0, player.slide_acceleration)


func enter_state_checks() -> void:
	if not player.slide_enabled or Time.get_ticks_msec() - player.slide_timestamp > player.slide_duration or player.velocity.length() < player.slide_stop_speed:
		transition_func.call(&"Grounded")
		return
	
	if player.slide_jump_enabled and Time.get_ticks_msec() - player.slide_timestamp >= player.slide_jump_delay and InputBuffer.is_action_buffered("jump"):
		player.slide_jump()
		transition_func.call(&"Jumping")
		return
	
	if player.slide_cancel_enabled and Time.get_ticks_msec() - player.slide_timestamp >= player.slide_cancel_delay and InputBuffer.is_action_buffered("slide"):
		transition_func.call(&"Grounded")
		return
