class_name PlayerCrouching extends State


@export var player: Player

@export var head: Node3D

@export var collision_shape: CollisionShape3D


func enter() -> void:
	player.crouch_timer = 0
	
	collision_shape.shape.height = player.standing_collider_height * player.crouch_height_multiplier
	collision_shape.position.y = player.standing_collider_y * player.crouch_height_multiplier


func exit() -> void:
	player.crouch_timer = player.crouch_transition_time
	
	collision_shape.shape.height = player.standing_collider_height
	collision_shape.position.y = player.standing_collider_y


func physics_update(delta: float) -> void:
	player.crouch_timer += delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed * player.crouch_speed_multiplier
	var acceleration: float = player.acceleration * player.crouch_acceleration_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta)
	player.add_friction(delta, player.friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
	
	
	if player.crouch_timer < player.crouch_transition_time and player.consume_jump_action_buffer():
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if Input.is_action_just_released("crouch"):
		transition.emit(&"PlayerGrounded")
