class_name PlayerGrounded extends State


@export var player: Player


func enter() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
	
	
	player.airborne_timer = 0
	
	if player.jump_action_timer <= player.jump_buffer_duration:
		if player.sprinting_action:
			player.jump(false, player.jump_power * player.sprint_jump_multiplier, player.horizontal_jump_power * player.sprint_horizontal_jump_multiplier)
		else:
			player.jump()
		
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	player.add_air_resistence(delta)
	player.add_friction(delta)
	
	if player.sprinting_action:
		player.add_movement(delta, player.top_speed * player.sprint_speed_multiplier, player.acceleration * player.sprint_acceleration_multiplier)
	else:
		player.add_movement(delta)
	
	
	if Input.is_action_just_pressed("jump"):
		if player.sprinting_action:
			player.jump(false, player.jump_power * player.sprint_jump_multiplier, player.horizontal_jump_power * player.sprint_horizontal_jump_multiplier)
		else:
			player.jump()
		
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
