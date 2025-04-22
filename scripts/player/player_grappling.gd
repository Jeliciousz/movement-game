class_name PlayerGrappling extends State


@export var player: Player


func update_physics_state() -> void:
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
		return
	
	if Input.is_action_just_released("secondary fire"):
		transition.emit(&"PlayerAirborne")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.air_speed * backwards_multiplier
	var acceleration: float = player.air_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_gravity(delta, player.physics_gravity)
	player.add_movement(delta, top_speed, acceleration)
	
	var direction_from_grapple: Vector3 = player.grapple_hook_point.direction_to(player.position)
	
	player.velocity += -direction_from_grapple * maxf(0, player.velocity.dot(direction_from_grapple))
	player.velocity += -direction_from_grapple * delta * 30
	
	
	DebugDraw3D.draw_line(player.position, player.grapple_hook_point, Color.BLACK)
