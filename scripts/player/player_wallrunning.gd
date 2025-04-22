class_name PlayerWallrunning extends State


@export var player: Player

@export var move_input: Node


func still_on_wall_check() -> bool:
	if player.is_on_wall():
		if not player.get_last_slide_collision().get_collider().is_in_group("WallrunBodies"):
			return true
		
		player.wallrun_wall_normal = Vector3(player.get_wall_normal().x, 0, player.get_wall_normal().z).normalized()
		
		player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
		
		var horizontal_velocity_direction: Vector3 = Vector3(player.velocity.x, 0, player.velocity.z).normalized()
		
		if player.wallrun_run_direction.dot(horizontal_velocity_direction) < 0:
			player.wallrun_run_direction *= -1
		
		return false
	
	var test = player.move_and_collide(-player.wallrun_wall_normal * 0.1, true)
	
	if not test:
		return true
	
	if not test.get_collider().is_in_group("WallrunBodies"):
		return true
	
	player.move_and_collide(-player.wallrun_wall_normal * 0.1)
	
	var wall_normal = Vector3(test.get_normal().x, 0, test.get_normal().z).normalized()
	
	if wall_normal.is_equal_approx(player.wallrun_wall_normal):
		return false
	
	var horizontal_speed = Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length()
	
	player.wallrun_wall_normal = wall_normal
	
	player.wallrun_run_direction = player.wallrun_wall_normal.rotated(Vector3.UP, deg_to_rad(90))
	
	var horizontal_velocity_direction: Vector3 = Vector3(player.velocity.x, 0, player.velocity.z).normalized()
	
	if player.wallrun_run_direction.dot(horizontal_velocity_direction) < 0:
		player.wallrun_run_direction *= -1
	
	return false


func enter() -> void:
	player.wallrun_timestamp = Time.get_ticks_msec()
	player.coyote_walljump_possible = true


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	var horizontal_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
	
	if horizontal_velocity.length() <= player.wallrun_stop_speed_threshold:
		transition.emit(&"PlayerAirborne")
		return
	
	if horizontal_velocity.normalized().dot(player.wallrun_run_direction) <= 0:
		transition.emit(&"PlayerAirborne")
		return
	
	if still_on_wall_check():
		transition.emit(&"PlayerAirborne")
		return
	
	var horizontal_colliding_speed = Vector2(player.colliding_velocity.x, player.colliding_velocity.z).length()
	
	player.velocity.x = player.wallrun_run_direction.x * horizontal_colliding_speed
	player.velocity.y = player.colliding_velocity.y
	player.velocity.z = player.wallrun_run_direction.z * horizontal_colliding_speed
	
	if InputBuffer.is_action_buffered("jump"):
		player.coyote_walljump_possible = false
		player.wall_jump()
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	player.add_air_resistence(delta, player.wallrun_air_resistence)
	
	if Time.get_ticks_msec() - player.wallrun_timestamp > player.wallrun_duration:
		player.add_friction(delta, player.wallrun_friction, player.wallrun_top_speed)
		player.add_gravity(delta, player.wallrun_gravity)
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.wallrun_vertical_friction * delta)
		
		player.add_wallrun_movement(delta)
