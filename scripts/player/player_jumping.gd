class_name PlayerJumping extends State


@export var player: Player


func enter() -> void:
	player.jump_timer = 0
	player.coyote_possible = false


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if not Input.is_action_pressed("jump") or player.jump_timer >= player.jump_duration:
		transition.emit(&"PlayerAirborne")


func physics_update(delta: float) -> void:
	player.airborne_timer += delta
	player.jump_timer += delta
	player.crouch_timer -= delta
	player.slide_end_timer += delta
	
	var top_speed: float = player.top_speed * player.airborne_speed_multiplier
	var acceleration: float = player.acceleration * player.airborne_acceleration_multiplier
	var gravity: float = player.gravity * player.jumping_gravity_multiplier
	
	var backwards_multiplier = lerpf(1, player.backwards_speed_multiplier, player.backwards_dot_product)
	top_speed *= backwards_multiplier
	
	player.add_air_resistence(delta)
	player.add_gravity(delta, gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	player.move_and_slide()
