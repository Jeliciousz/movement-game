class_name PlayerAirborne extends State


@export var player: Player


func coyote_jump_check() -> bool:
	if player.coyote_possible and player.airborne_timer <= player.jump_coyote_time and player.consume_jump_action_buffer():
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		if player.move_direction.is_zero_approx():
			jump_power *= player.standing_jump_multiplier
			horizontal_jump_power = 0
		elif player.sprint_action:
			jump_power *= player.sprint_jump_multiplier
			horizontal_jump_power *= player.sprint_horizontal_jump_multiplier
		
		player.jump(jump_power, horizontal_jump_power * backwards_multiplier, player.move_direction, true, false)
		
		transition.emit(&"PlayerJumping")
		return true
	
	return false


func air_jump_check() -> bool:
	if player.air_jumps < player.air_jumps_limit and player.consume_jump_action_buffer():
		player.air_jumps += 1
		
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		if player.move_direction.is_zero_approx():
			jump_power *= player.standing_jump_multiplier
			horizontal_jump_power = 0
		
		player.jump(jump_power, horizontal_jump_power * backwards_multiplier, player.move_direction, true, true)
		
		transition.emit(&"PlayerJumping")
		return true
	
	return false


func wallrun_check() -> bool:
	if player.is_on_wall() and player.sprint_action and player.horizontal_colliding_speed >= player.wallrun_start_speed_threshold:
		var wall_normal = player.get_wall_normal()
		
		var wall_product = player.horizontal_colliding_direction.dot(-wall_normal)
		
		if cos(player.wallrun_maximum_angle_threshold) < wall_product and wall_product < cos(player.wallrun_minimum_angle_threshold):
			player.wallrun_wall_normal = wall_normal
			#player.velocity = player.horizontal_velocity_direction * player.horizontal_colliding_speed * player.wallrun_speed_conversion_multiplier
			player.velocity = player.velocity_direction * player.colliding_speed * player.wallrun_speed_conversion_multiplier
			transition.emit(&"PlayerWallrunning")
			return true
	
	return false


func enter() -> void:
	if wallrun_check():
		return
	
	if coyote_jump_check():
		return
	
	if air_jump_check():
		return


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if wallrun_check():
		return
	
	if coyote_jump_check():
		return
	
	if air_jump_check():
		return


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed * player.airborne_speed_multiplier
	var acceleration: float = player.acceleration * player.airborne_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_gravity(delta, player.gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
