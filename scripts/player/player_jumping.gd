class_name PlayerJumping extends State


@export var player: Player


func enter() -> void:
	player.jump_timestamp = Time.get_ticks_msec()
	
	player.coyote_jump_possible = false
	player.coyote_slide_possible = false


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if Time.get_ticks_msec() - player.jump_timestamp >= player.jump_duration or not Input.is_action_pressed("jump"):
		transition.emit(&"PlayerAirborne")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	var gravity: float = player.physics_gravity * player.jump_gravity_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, gravity)
	player.add_movement(delta, top_speed, acceleration)
