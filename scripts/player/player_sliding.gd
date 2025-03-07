class_name PlayerSliding extends State


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
	player.slide_timer += delta
	
	player.add_air_resistence(delta)
	player.add_friction(delta, 0, player.friction * player.slide_friction_multiplier)
	player.add_movement(delta, 0, player.acceleration * player.slide_acceleration_multiplier)
	
	
	if Input.is_action_just_pressed("jump"):
		player.slide_jump()
		transition.emit(&"PlayerAirborne")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if player.slide_timer > player.slide_duration:
		transition.emit(&"PlayerGrounded")
		return
	
	if Input.is_action_just_pressed("crouch"):
		player.crouch_action_timer = 999
		transition.emit(&"PlayerGrounded")
