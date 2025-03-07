class_name PlayerGrounded extends State


@export var player: Player


func enter() -> void:
	player.airborne_timer = 0
	
	if player.jump_action_timer <= player.jump_buffer_duration:
		player.jump()
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")


func physics_update(delta: float) -> void:
	player.add_air_resistence(delta)
	player.add_friction(delta)
	player.add_movement(delta)
	
	
	if Input.is_action_just_pressed("jump"):
		player.jump()
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
