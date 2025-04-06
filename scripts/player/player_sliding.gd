class_name PlayerSliding extends State


@export var player: Player

@export var player_collider: CollisionShape3D


@onready var base_collider_height: float = player_collider.shape.height


func enter() -> void:
	player_collider.shape.height = base_collider_height * player.crouch_height_multiplier
	player_collider.position.y = base_collider_height / 2 * player.crouch_height_multiplier
	
	player.crouch_timestamp = Time.get_ticks_msec()
	player.slide_timestamp = Time.get_ticks_msec()
	
	player.coyote_slide_possible = false
	
	# Slide Jumping
	if InputBuffer.is_action_buffered("jump"):
		player.coyote_jump_possible = false
		player.slide_jump()
		transition.emit(&"PlayerAirborne")
		return


func exit() -> void:
	player_collider.shape.height = base_collider_height
	player_collider.position.y = base_collider_height / 2
	
	player.crouch_timestamp = Time.get_ticks_msec()
	player.slide_timestamp = Time.get_ticks_msec()


func update_physics_state() -> void:
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
		return
	
	if Time.get_ticks_msec() - player.slide_timestamp > player.slide_duration:
		transition.emit(&"PlayerGrounded")
		return
	
	# Slide Jumping
	if InputBuffer.is_action_buffered("jump"):
		player.coyote_jump_possible = false
		player.slide_jump()
		transition.emit(&"PlayerAirborne")
		return
	
	# Slide Cancel
	if InputBuffer.is_action_buffered("crouch"):
		transition.emit(&"PlayerGrounded")
		return


func physics_update(delta: float) -> void:
	var friction: float = player.slide_friction
	var acceleration: float = player.slide_acceleration
	
	player.add_air_resistence(delta, player.physics_air_resistence)
	player.add_friction(delta, friction, 0)
	player.add_movement(delta, 0, acceleration)
