class_name PlayerCrouching extends State


@export var player: Player

@export var player_collider: CollisionShape3D

@export var standing_area: Area3D


@onready var base_collider_height: float = player_collider.shape.height


func enter() -> void:
	player_collider.shape.height = base_collider_height * player.crouch_height_multiplier
	player_collider.position.y = base_collider_height / 2 * player.crouch_height_multiplier
	
	player.crouch_timestamp = Time.get_ticks_msec()
	
	# Crouch Jumping
	if InputBuffer.is_action_buffered("jump"):
		player.jump()
		transition.emit(&"PlayerJumping")
		return


func exit() -> void:
	player_collider.shape.height = base_collider_height
	player_collider.position.y = base_collider_height / 2
	
	player.crouch_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if not standing_area.has_overlapping_bodies() and not Input.is_action_pressed("slide-crouch"):
		transition.emit(&"PlayerGrounded")
		return
	
	# Crouch Jumping
	if Time.get_ticks_msec() - player.crouch_timestamp <= player.jump_coyote_duration and not standing_area.has_overlapping_bodies() and InputBuffer.is_action_buffered("jump"):
		player.jump()
		transition.emit(&"PlayerJumping")
		return


func physics_update(delta: float) -> void:
	var backwards_multiplier = lerpf(1, player.move_backwards_multiplier, player.get_amount_moving_backwards())
	
	var top_speed: float = player.crouch_speed * backwards_multiplier
	var acceleration: float = player.crouch_acceleration * backwards_multiplier
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_friction(delta, player.physics_friction, top_speed)
	player.add_movement(delta, top_speed, acceleration)
