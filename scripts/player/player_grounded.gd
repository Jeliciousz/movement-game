class_name PlayerGrounded extends State


@export var player: Player


func enter() -> void:
	player.air_jumps = 0
	player.air_dashes = 0
	player.coyote_jump_possible = true
	player.coyote_slide_possible = true
	#player.wallrun_wall_normal = Vector3.ZERO
	
	var speed = player.velocity.length()
	
	# Crouching
	if (speed < player.slide_speed_threshold or not player.is_sprinting) and InputBuffer.is_action_buffered("crouch"):
		transition.emit(&"PlayerCrouching")
		return
	
	# Sliding
	if Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and is_zero_approx(player.get_amount_moving_backwards()) and InputBuffer.is_action_buffered("crouch"):
		player.add_velocity(player.slide_power, player.move_direction)
		transition.emit(&"PlayerSliding")
		return
	
	# Jumping
	if InputBuffer.is_action_buffered("jump"):
		player.jump()
		transition.emit(&"PlayerJumping")
		return


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	# Sprinting
	if Input.is_action_just_pressed("sprint"):
		player.is_sprinting = not player.is_sprinting
	
	var speed = player.velocity.length()
	
	# Crouching
	if (speed < player.slide_speed_threshold or not player.is_sprinting) and InputBuffer.is_action_buffered("crouch"):
		transition.emit(&"PlayerCrouching")
		return
	
	# Sliding
	if Time.get_ticks_msec() - player.slide_timestamp > player.slide_cooldown_duration and is_zero_approx(player.get_amount_moving_backwards()) and InputBuffer.is_action_buffered("crouch"):
		player.add_velocity(player.slide_power, player.move_direction)
		transition.emit(&"PlayerSliding")
		return
	
	# Jumping
	if InputBuffer.is_action_buffered("jump"):
		player.jump()
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float
	var acceleration: float
	
	if player.is_sprinting:
		top_speed = player.sprint_speed * backwards_multiplier
		acceleration = player.sprint_acceleration * backwards_multiplier
	else:
		top_speed = player.move_speed * backwards_multiplier
		acceleration = player.move_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_friction(delta, player.physics_friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
