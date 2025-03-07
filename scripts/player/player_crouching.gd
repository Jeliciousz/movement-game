class_name PlayerCrouching extends State


@export var player: Player

@export var head: Node3D

@export var collision_shape: CollisionShape3D


func enter() -> void:
	player.crouch_timer = 0
	
	collision_shape.shape.height *= player.crouch_height_multiplier
	collision_shape.position.y *= player.crouch_height_multiplier


func exit() -> void:
	player.crouch_timer = player.crouch_transition_time
	
	collision_shape.shape.height /= player.crouch_height_multiplier
	collision_shape.position.y /= player.crouch_height_multiplier


func physics_update(delta: float) -> void:
	player.crouch_timer += delta
	
	player.add_air_resistence(delta)
	player.add_friction(delta, player.top_speed * player.crouch_speed_multiplier)
	player.add_movement(delta, player.top_speed * player.crouch_speed_multiplier, player.acceleration * player.crouch_acceleration_multiplier)
	
	
	if player.crouch_timer < player.crouch_transition_time and Input.is_action_just_pressed("jump"):
		player.jump()
		
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if Input.is_action_just_released("crouch"):
		transition.emit(&"PlayerGrounded")
