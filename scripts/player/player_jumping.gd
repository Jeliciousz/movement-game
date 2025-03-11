class_name PlayerJumping extends State


@export var player: Player


func enter() -> void:
	player.jump_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if not Input.is_action_pressed("jump") or Time.get_ticks_msec() - player.jump_timestamp >= player.jump_duration:
		transition.emit(&"PlayerAirborne")


func physics_update(delta: float) -> void:
	var top_speed: float = player.top_speed * player.airborne_speed_multiplier
	var acceleration: float = player.acceleration * player.airborne_acceleration_multiplier
	var gravity: float = player.gravity * player.jumping_gravity_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_gravity(delta, gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
