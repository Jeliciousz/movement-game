class_name PlayerCrouching extends State


@export var player: Player

@export var head: Node3D


func enter() -> void:
	player.crouch_timer = 0
	
	head.position.y -= 1


func exit() -> void:
	player.crouch_timer = 0
	
	head.position.y += 1


func physics_update(delta: float) -> void:
	player.add_air_resistence(delta)
	player.add_friction(delta)
	
	player.add_movement(delta, player.top_speed * player.crouch_speed_multiplier, player.acceleration * player.crouch_acceleration_multiplier)
	
	
	if Input.is_action_just_pressed("jump") and player.crouch_timer < player.crouch_transition_time:
		player.jump()
		
		transition.emit(&"PlayerJumping")
		return
	
	if not player.is_on_floor():
		transition.emit(&"PlayerAirborne")
