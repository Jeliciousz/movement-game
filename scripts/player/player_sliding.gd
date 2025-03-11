class_name PlayerSliding extends State


@export var player: Player

@export var head: Node3D

@export var collision_shape: CollisionShape3D


func slide_jump_check() -> bool:
	if InputBuffer.is_action_buffered("jump"):
		player.jump(player.slide_jump_power, player.slide_horizontal_jump_power, player.horizontal_velocity_direction, true, false)
		transition.emit(&"PlayerAirborne")
		return true
	
	return false


func enter() -> void:
	collision_shape.shape.height *= player.crouch_height_multiplier
	collision_shape.position.y *= player.crouch_height_multiplier
	
	player.crouch_timestamp = Time.get_ticks_msec()
	player.slide_timestamp = Time.get_ticks_msec()
	
	if slide_jump_check():
		return


func exit() -> void:
	collision_shape.shape.height /= player.crouch_height_multiplier
	collision_shape.position.y /= player.crouch_height_multiplier
	
	player.crouch_timestamp = Time.get_ticks_msec()
	player.slide_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if Time.get_ticks_msec() - player.slide_timestamp > player.slide_duration:
		transition.emit(&"PlayerGrounded")
		return
	
	if slide_jump_check():
		return
	
	if InputBuffer.is_action_buffered("crouch"):
		transition.emit(&"PlayerGrounded")


func physics_update(delta: float) -> void:
	var friction: float = player.friction * player.slide_friction_multiplier
	var acceleration: float = player.acceleration * player.slide_acceleration_multiplier
	
	player.add_air_resistence(delta, player.air_resistence)
	player.add_friction(delta, friction, 0)
	player.add_movement(delta, player.move_direction, 0, acceleration)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
