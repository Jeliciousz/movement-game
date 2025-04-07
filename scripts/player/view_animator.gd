extends Node


@export_group("Player Nodes", "player_")
@export var player: Player

@export var player_state_machine: StateMachine

@export var player_head: Node3D

@export_group("Head Bob", "head_bob_")
@export var head_bob_height: float = 0.05

@export var head_bob_speed: float = 0.45

@export_group("Inertia", "inertia_")
@export var inertia_damping: float = 30

@export var inertia_restitution: float = 500

@export var inertia_acceleration_affect: float = 20

@onready var standing_head_y: float = player_head.position.y


var head_target_position: Vector3 = Vector3.ZERO

var head_bob_t: float = 0

var last_player_velocity: Vector3 = Vector3.ZERO

var player_acceleration: Vector3 = Vector3.ZERO

var head_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	match player_state_machine.current_state.name:
		&"PlayerCrouching":
			head_target_position = Vector3(0, standing_head_y * player.crouch_height_multiplier, 0)
			
			var player_speed = player.velocity.length()
			
			if player_speed < 1:
				head_bob_t = 0
			else:
				head_bob_t += delta * player_speed * (head_bob_speed / player.crouch_height_multiplier)
				
				head_target_position.y += sin(head_bob_t * PI * 2) * (head_bob_height / player.crouch_height_multiplier)
		&"PlayerSliding":
			head_target_position = Vector3(0, standing_head_y * player.crouch_height_multiplier, 0)
		&"PlayerGrounded":
			head_target_position = Vector3(0, standing_head_y, 0)
			
			var player_speed = player.velocity.length()
			
			if player_speed < 1:
				head_bob_t = 0
			else:
				head_bob_t += delta * player_speed * head_bob_speed
				
				head_target_position.y += sin(head_bob_t * PI * 2) * head_bob_height
		_:
			head_target_position = Vector3(0, standing_head_y, 0)
	
	
	player_acceleration = player.velocity - last_player_velocity
	
	last_player_velocity = player.velocity
	
	# Damping Force
	head_velocity -= head_velocity * delta * inertia_damping
	
	# Restitution force
	head_velocity += (head_target_position - player_head.position) * delta * inertia_restitution
	
	# Inertia
	head_velocity -= player.transform.basis.inverse() * delta * player_acceleration * inertia_acceleration_affect
	
	player_head.position += head_velocity * delta
