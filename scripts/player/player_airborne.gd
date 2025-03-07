class_name PlayerAirborne extends State


@export var player: Player


func enter() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	
	player.add_air_resistence(delta)
	player.add_gravity(delta)
	player.add_movement(delta, player.top_speed * player.airborne_speed_multiplier, player.acceleration * player.airborne_acceleration_multiplier)
	
	
	if Input.is_action_just_pressed("jump") and player.airborne_timer <= player.jump_coyote_time:
		player.jump(true)
		transition.emit(&"PlayerJumping")
		return
	
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
