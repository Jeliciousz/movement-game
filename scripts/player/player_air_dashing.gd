class_name PlayerAirdashing extends State


@export var player: Player


func wallrun_check() -> bool:
	if player.is_on_wall() and player.horizontal_colliding_speed >= player.wallrun_start_speed_threshold:
		var wall_normal = player.get_wall_normal()
		
		var wall_product = player.horizontal_colliding_direction.dot(-wall_normal)
		
		if cos(player.wallrun_maximum_angle_threshold) < wall_product and wall_product < cos(player.wallrun_minimum_angle_threshold):
			player.wallrun_wall_normal = wall_normal
			player.velocity = player.velocity_direction * player.colliding_speed * player.wallrun_speed_conversion_multiplier
			transition.emit(&"PlayerWallrunning")
			return true
	
	return false


func air_jump_check() -> bool:
	if player.air_jumps < player.air_jumps_limit and Input.is_action_just_pressed("jump"):
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


func enter() -> void:
	player.air_dash_timestamp = Time.get_ticks_msec()
	player.air_dashes += 1
	
	player.velocity = player.looking_direction * player.air_dash_power
	player.velocity.y += player.vertical_air_dash_power
	
	if wallrun_check():
		return
	
	if air_jump_check():
		return


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if Time.get_ticks_msec() - player.air_dash_timestamp > player.air_dash_duration:
		player.velocity = player.velocity.move_toward(Vector3.ZERO, player.air_dash_end_power)
		transition.emit(&"PlayerAirborne")
		return
	
	if wallrun_check():
		return
	
	if air_jump_check():
		return


func physics_update(delta: float) -> void:
	player.colliding_velocity = player.velocity
	player.move_and_slide()
