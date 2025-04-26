class_name PlayerGrappleHookingState extends PlayerState


func enter() -> void:
    player.grapple_hook_point.targeted = player.grapple_hook_point.NOT_TARGETED
	
	player.coyote_jump_active = false
	player.coyote_slide_active = false
	player.coyote_walljump_active = false


func state_checks() -> void:
	update_stance()
	
	if player.is_on_floor():
		transition_func.call(&"Grounded")
		return
	
	if Input.is_action_just_pressed("grapple_hook"):
		transition_func.call(&"Airborne")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier: float = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, player.physics_gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	var direction_from_grapple: Vector3 = player.grapple_hook_point.position.direction_to(player.head.global_position)
	
	player.velocity += -direction_from_grapple * maxf(0, player.velocity.dot(direction_from_grapple))
	
	var distance_from_grapple: float = player.grapple_hook_point.position.distance_to(player.head.global_position)
	
	var weight: float = clampf((distance_from_grapple - player.standing_height) / (player.grapple_hook_max_distance - player.standing_height), 0, 1)
	
	var power: float = lerpf(0, player.grapple_hook_power, weight)
	
	player.velocity += -direction_from_grapple * maxf(0, (power - player.velocity.dot(-direction_from_grapple)))


func update(_delta: float) -> void:
	DebugDraw3D.draw_line(player.head.global_position + player.get_looking_direction() * 0.4, player.grapple_hook_point.position, Color.BLACK)


func update_stance() -> void:
	match player.active_stance:
		player.Stances.STANDING, player.Stances.SPRINTING:
			if player.air_crouch_enabled and player.air_crouches < player.air_crouch_limit and Input.is_action_pressed("crouch"):
				player.crouch()
				player.air_crouches += 1
		
		player.Stances.CROUCHING:
			if not (player.crouch_enabled and Input.is_action_pressed("crouch")):
				player.attempt_uncrouch()
