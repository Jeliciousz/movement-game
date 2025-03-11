class_name PlayerCrouching extends State


@export var player: Player

@export var head: Node3D

@export var collision_shape: CollisionShape3D


func jump_check() -> bool:
	if Time.get_ticks_msec() - player.crouch_timestamp < player.crouch_transition_time and InputBuffer.is_action_buffered("jump"):
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		if player.move_direction.is_zero_approx():
			jump_power *= player.standing_jump_multiplier
			horizontal_jump_power = 0
		
		player.jump(jump_power, horizontal_jump_power * backwards_multiplier, player.move_direction, false, false)
		
		transition.emit(&"PlayerJumping")
		return true
	
	return false


func enter() -> void:
	collision_shape.shape.height = player.standing_collider_height * player.crouch_height_multiplier
	collision_shape.position.y = player.standing_collider_y * player.crouch_height_multiplier
	
	player.crouch_timestamp = Time.get_ticks_msec()
	
	if jump_check():
		return


func exit() -> void:
	collision_shape.shape.height = player.standing_collider_height
	collision_shape.position.y = player.standing_collider_y
	
	player.crouch_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if jump_check():
		return
	
	if not Input.is_action_pressed("crouch"):
		transition.emit(&"PlayerGrounded")


func physics_update(delta: float) -> void:
	var top_speed: float = player.top_speed * player.crouch_speed_multiplier
	var acceleration: float = player.acceleration * player.crouch_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_friction(delta, player.friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
