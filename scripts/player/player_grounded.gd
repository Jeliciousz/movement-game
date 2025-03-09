class_name PlayerGrounded extends State


@export var player: Player


func crouch_slide_check() -> bool:
	if player.consume_crouch_action_buffer():
		if not player.sprint_action or player.speed < player.slide_speed_threshold:
			transition.emit(&"PlayerCrouching")
			return true
		
		if player.slide_end_timer > player.slide_cooldown_duration:
			player.slide(player.slide_power)
			transition.emit(&"PlayerSliding")
			return true
	
	return false


func jump_check() -> bool:
	if player.consume_jump_action_buffer():
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		if player.sprint_action:
			jump_power *= player.sprint_jump_multiplier
			horizontal_jump_power *= player.sprint_horizontal_jump_multiplier
		
		player.jump(jump_power, horizontal_jump_power, false, false)
		
		transition.emit(&"PlayerJumping")
		return true
	
	return false


func enter() -> void:
	player.airborne_timer = 0
	player.air_jumps = 0
	player.coyote_possible = true
	
	if crouch_slide_check():
		return
	
	if jump_check():
		return


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if crouch_slide_check():
		return
	
	if jump_check():
		return


func physics_update(delta: float) -> void:
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed
	var acceleration: float = player.acceleration
	
	if player.sprint_action:
		top_speed *= player.sprint_speed_multiplier
		acceleration *= player.sprint_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta)
	player.add_friction(delta, player.friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
	
	player.move_and_slide()
