class_name PlayerSliding extends State


@export var player: Player

@export var head: Node3D

@export var collision_shape: CollisionShape3D


func slide_jump_check() -> bool:
	if player.consume_jump_action_buffer():
		player.coyote_possible = false
		player.jump(player.slide_jump_power, player.slide_horizontal_jump_power, player.horizontal_velocity_direction, true, false)
		transition.emit(&"PlayerAirborne")
		return true
	
	return false


func enter() -> void:
	player.crouch_timer = 0
	
	collision_shape.shape.height *= player.crouch_height_multiplier
	collision_shape.position.y *= player.crouch_height_multiplier
	
	player.slide_timer = 0
	
	if slide_jump_check():
		return


func exit() -> void:
	player.crouch_timer = player.crouch_transition_time
	
	collision_shape.shape.height /= player.crouch_height_multiplier
	collision_shape.position.y /= player.crouch_height_multiplier
	
	player.slide_end_timer = 0


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if player.slide_timer > player.slide_duration:
		transition.emit(&"PlayerGrounded")
		return
	
	if slide_jump_check():
		return
	
	if player.consume_crouch_action_buffer():
		transition.emit(&"PlayerGrounded")


func physics_update(delta: float) -> void:
	player.crouch_timer += delta
	player.slide_timer += delta
	
	var friction: float = player.friction * player.slide_friction_multiplier
	var acceleration: float = player.acceleration * player.slide_acceleration_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_friction(delta, friction, 0)
	player.add_movement(delta, 0, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
