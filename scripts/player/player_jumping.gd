class_name PlayerJumping extends State


@export var player: Player


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	player.jump_timer += delta
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	player.add_air_resistence(delta)
	player.add_gravity(delta, player.gravity * player.jumping_gravity_multiplier)
	player.add_movement(delta, player.top_speed * player.airborne_speed_multiplier, player.acceleration * player.airborne_acceleration_multiplier)
	
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if player.jump_timer >= player.jump_duration or not Input.is_action_pressed("jump"):
		transition.emit(&"PlayerAirborne")
