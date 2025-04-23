extends Node


@export_group("Player Nodes", "player_")

@export var player: Player

@export var player_head: Node3D

@export var player_camera: Camera3D

@export var player_footsteps_audio: AudioStreamPlayer3D

@export_group("Head Bob", "head_bob_")

@export var head_bob_height: float = 0.05

@export var head_bob_speed: float = 0.45

@export_group("Tilting", "tilt_")

@export var tilt_strafing: float = 0.0025

@export var tilt_sliding_horizontal: float = 0.002

@export var tilt_sliding_forward: float = 0.001

@export_group("Wall-Running", "wallrun_")

@export var wallrun_tilt: float = 0.005

@export var wallrun_headbob_multiplier: float = 0.5

@export_group("Inertia", "inertia_")

@export var inertia_damping: float = 30

@export var inertia_restitution: float = 500

@export var inertia_acceleration_affect: float = 20

@export var inertia_rotation_lerp: float = 15

@onready var standing_head_y: float = player_head.position.y


var head_target_position: Vector3 = Vector3.ZERO

var camera_target_rotation: Vector3 = Vector3.ZERO

var head_bob_t: float = 0

var last_head_y: float = 0

var footstep_taken: bool = false

var last_player_velocity: Vector3 = Vector3.ZERO

var player_acceleration: Vector3 = Vector3.ZERO

var head_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	# Get player acceleration
	player_acceleration = player.velocity - last_player_velocity
	
	last_player_velocity = player.velocity
	
	var player_speed = player.velocity.length()
	
	if player.active_stance == player.Stances.Crouching:
		head_target_position = Vector3(0, standing_head_y * player.crouch_height_multiplier, 0)
	else:
		head_target_position = Vector3(0, standing_head_y, 0)
	
	match player.active_state:
		player.States.Grounded:
			camera_target_rotation = Vector3(0, 0, -(player.transform.basis.inverse() * player.velocity).x * PI * tilt_strafing)
			
			if player_speed < 1 or player.move_direction.is_zero_approx():
				head_bob_t = 0
			else:
				if player.active_stance == player.Stances.Crouching:
					head_bob_t += delta * player_speed * (head_bob_speed / player.crouch_height_multiplier)
					
					head_target_position.y += sin(head_bob_t * PI * 2) * (head_bob_height / player.crouch_height_multiplier)
				else:
					head_bob_t += delta * player_speed * head_bob_speed
					
					head_target_position.y += sin(head_bob_t * PI * 2) * head_bob_height
				
				if head_target_position.y - last_head_y <= 0:
					footstep_taken = false
				elif not footstep_taken:
					player_footsteps_audio.play()
					footstep_taken = true
				
				last_head_y = head_target_position.y
		player.States.Sliding:
			camera_target_rotation = Vector3(-(player.transform.basis.inverse() * player.velocity).z * PI * tilt_sliding_forward, 0, (player.transform.basis.inverse() * player.velocity).x * PI * tilt_sliding_horizontal)
		player.States.WallRunning:
			camera_target_rotation = Vector3(0, 0, -(player.transform.basis.inverse() * player.wallrun_wall_normal).x * PI * wallrun_tilt)
			
			if player_speed < 1 or player.move_direction.is_zero_approx():
				head_bob_t = 0
			else:
				head_bob_t += delta * player_speed * head_bob_speed * wallrun_headbob_multiplier
				
				head_target_position.y += sin(head_bob_t * PI * 2) * head_bob_height
				
				if head_target_position.y - last_head_y <= 0:
					footstep_taken = false
				elif not footstep_taken:
					player_footsteps_audio.play()
					footstep_taken = true
				
				last_head_y = head_target_position.y
		_:
			camera_target_rotation = Vector3(0, 0, -(player.transform.basis.inverse() * player.velocity).x * PI * tilt_strafing)
	
	# Damping Force
	head_velocity -= head_velocity * delta * inertia_damping
	
	# Restitution force
	head_velocity += (head_target_position - player_head.position) * delta * inertia_restitution
	
	# Inertia
	head_velocity -= player.transform.basis.inverse() * delta * player_acceleration * inertia_acceleration_affect
	
	
	player_head.position += head_velocity * delta
	
	
	player_camera.rotation = player_camera.rotation.lerp(camera_target_rotation, delta * inertia_rotation_lerp)
