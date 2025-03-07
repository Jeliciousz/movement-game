class_name PlayerJumping extends State


@export var player: Player


func enter() -> void:
	var jump_power = player.jump_power
	var horizontal_jump_power = player.horizontal_jump_power
	
	if player.sprint_action:
		jump_power *= player.sprint_jump_multiplier
		horizontal_jump_power *= player.sprint_horizontal_jump_multiplier
	
	player.jump(jump_power, horizontal_jump_power, false)
	player.jump_timer = 0


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	player.jump_timer += delta
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed * player.airborne_speed_multiplier
	var acceleration: float = player.acceleration * player.airborne_acceleration_multiplier
	var gravity: float = player.gravity * player.jumping_gravity_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta)
	player.add_gravity(delta, gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if Input.is_action_just_released("jump") or player.jump_timer >= player.jump_duration:
		transition.emit(&"PlayerAirborne")
