class_name PlayerGrounded extends State


@export var player: Player


func crouch_slide_check() -> bool:
	if InputBuffer.is_action_buffered("crouch"):
		if not player.is_sprinting or player.speed < player.slide_speed_threshold:
			transition.emit(&"PlayerCrouching")
			return true
		
		if Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration:
			player.add_force(player.slide_power, player.move_direction)
			transition.emit(&"PlayerSliding")
			return true
	
	return false


func jump_check() -> bool:
	if InputBuffer.is_action_buffered("jump"):
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		if player.move_direction.is_zero_approx():
			jump_power *= player.standing_jump_multiplier
			horizontal_jump_power = 0
		elif player.is_sprinting:
			jump_power *= player.sprint_jump_multiplier
			horizontal_jump_power *= player.sprint_horizontal_jump_multiplier
		
		player.jump(jump_power, horizontal_jump_power * backwards_multiplier, player.move_direction, false, false)
		
		transition.emit(&"PlayerJumping")
		return true
	
	return false


func enter() -> void:
	player.air_jumps = 0
	player.air_dashes = 0
	
	if crouch_slide_check():
		return
	
	if jump_check():
		return


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if InputBuffer.is_action_buffered("sprint"):
		player.is_sprinting = not player.is_sprinting
	
	if crouch_slide_check():
		return
	
	if jump_check():
		return


func physics_update(delta: float) -> void:
	var top_speed: float = player.top_speed
	var acceleration: float = player.acceleration
	
	if player.is_sprinting:
		top_speed *= player.sprint_speed_multiplier
		acceleration *= player.sprint_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_friction(delta, player.friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
