class_name PlayerAirborne extends State


@export var player: Player


func enter() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed * player.airborne_speed_multiplier
	var acceleration: float = player.acceleration * player.airborne_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta)
	player.add_gravity(delta, player.gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	
	if player.airborne_timer <= player.jump_coyote_time and player.consume_jump_action_buffer():
		transition.emit(&"PlayerJumping")
		return
	
	if player.air_jumps < player.air_jumps_limit and player.consume_jump_action_buffer():
		player.air_jumps += 1
		transition.emit(&"PlayerJumping")
		return
	
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
