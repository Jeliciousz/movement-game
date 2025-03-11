class_name PlayerWallrunning extends State


@export var player: Player


func enter() -> void:
	player.wallrun_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if not player.is_on_wall():
		transition.emit(&"PlayerAirborne")
		return
	
	if not player.get_last_slide_collision().get_collider().has_node("CanWallrun"):
		transition.emit(&"PlayerAirborne")
		return
	
	if player.horizontal_speed < player.wallrun_stop_speed_threshold:
		transition.emit(&"PlayerAirborne")
		return
	
	if InputBuffer.is_action_buffered("jump"):
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		var wall_dot_product = minf(1 - player.move_direction.dot(player.wallrun_wall_normal), 1)
		
		player.jump(jump_power, 0, player.move_direction, true, false)
		player.add_force(player.wallrun_kick_power, player.wallrun_wall_normal)
		transition.emit(&"PlayerJumping")


func physics_update(delta: float) -> void:
	var air_resistence: float = player.air_resistence * player.wallrun_air_resistence_multiplier
	var friction: float = player.friction * player.wallrun_friction_multiplier
	
	player.add_air_resistence(delta, air_resistence)
	
	if Time.get_ticks_msec() - player.wallrun_timestamp > player.wallrun_duration:
		var gravity: float = player.gravity * player.wallrun_gravity_multiplier
		
		player.add_friction(delta, friction, player.wallrun_top_speed)
		player.add_gravity(delta, gravity)
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.wallrun_vertical_friction * delta)
		
		player.add_movement(delta, player.wallrun_top_speed, player.wallrun_acceleration)
		
		var wallrun_wall_parallel: Vector3 = abs(player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90)))
		
		player.velocity.x *= wallrun_wall_parallel.x
		player.velocity.z *= wallrun_wall_parallel.z
	
	player.add_force(1, -player.wallrun_wall_normal)
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
