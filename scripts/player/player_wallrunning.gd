class_name PlayerWallrunning extends State


@export var player: Player


func enter() -> void:
	player.wallrun_timer = 0


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if player.horizontal_speed < player.wallrun_stop_speed_threshold:
		transition.emit(&"PlayerAirborne")
		return
	
	if player.consume_jump_action_buffer():
		var jump_power = player.jump_power
		var horizontal_jump_power = player.horizontal_jump_power
		
		var backwards_multiplier = lerpf(1, player.backwards_jump_multiplier, player.backwards_dot_product)
		
		var wall_dot_product = minf(1 - player.move_direction.dot(player.wallrun_wall_normal), 1)
		#horizontal_jump_power * backwards_multiplier * wall_dot_product
		player.jump(jump_power, 0, player.move_direction, true, false)
		player.add_force(player.wallrun_kick_power, player.wallrun_wall_normal)
		transition.emit(&"PlayerJumping")


func physics_update(delta: float) -> void:
	player.wallrun_timer += delta
	
	player.add_air_resistence(delta)
	
	if player.wallrun_timer > player.wallrun_duration:
		var friction: float = player.friction * player.wallrun_friction_multiplier
		var gravity: float = player.gravity * player.wallrun_gravity_multiplier
		
		player.add_friction(delta, friction, player.wallrun_top_speed)
		player.add_gravity(delta, gravity)
	else:
		player.add_movement(delta, player.wallrun_top_speed, player.wallrun_acceleration)
		
		var wallrun_wall_parallel: Vector3 = abs(player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90)))
		
		player.velocity.x *= wallrun_wall_parallel.x
		player.velocity.z *= wallrun_wall_parallel.z
	
	player.colliding_velocity = player.velocity
	player.move_and_slide()
