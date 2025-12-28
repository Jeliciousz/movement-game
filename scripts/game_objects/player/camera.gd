class_name PlayerCamera
extends Camera3D
## Controls the [Player]'s camera. Accounts for per-frame rotation, with interpolated translation.
## Animates the camera based on the Player's state.

## The [Player].
@export var player: Player
## How quickly the camera rotates.
@export var rotation_offset_speed: float = 10.0
## How much the player's velocity influences the camera rotation.
@export var rotation_offset_velocity_influence: float = 0.5
## How much the camera is tilted away from a wall the player is running on.
@export var rotation_offset_wallrun_influence: float = 5.0
## How much the camera is tilted upwards when sliding.
@export var rotation_offset_slide_pitch_influence: float = 1.0
## How much the camera is rolled when sliding sideways.
@export var rotation_offset_slide_roll_influence: float = 1.0
## How quickly the camera goes back down after starting a slide.
@export var rotation_offset_slide_return_speed: float = 2.0
## How much the camera is tilted up while ledge grabbing.
@export var rotation_offset_ledge_grab_influence: float = 15.0

var rotation_offset: Vector3 = Vector3.ZERO
var head_velocity: Vector3 = Vector3.ZERO
var last_head_position: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:
	var target_rotation_offset: Vector3 = -Vector3(deg_to_rad(rotation_offset_velocity_influence) * head_velocity.dot(player.basis.y), 0.0, deg_to_rad(rotation_offset_velocity_influence) * head_velocity.dot(player.basis.x))

	match player.state_machine.get_state_name():
		&"WallRunning":
			target_rotation_offset.z -= deg_to_rad(rotation_offset_wallrun_influence) * player.wall_normal.dot(player.basis.x)
		&"Sliding":
			target_rotation_offset += Vector3(deg_to_rad(rotation_offset_slide_pitch_influence) * (head_velocity.dot(-player.basis.z) - player.slide_stop_speed), 0.0, deg_to_rad(rotation_offset_slide_roll_influence) * head_velocity.dot(player.basis.x))
		&"LedgeGrabbing":
			target_rotation_offset += Vector3(deg_to_rad(rotation_offset_ledge_grab_influence), 0.0, 0.0)

	rotation_offset.x += angle_difference(rotation_offset.x, target_rotation_offset.x) * delta * rotation_offset_speed
	rotation_offset.y += angle_difference(rotation_offset.y, target_rotation_offset.y) * delta * rotation_offset_speed
	rotation_offset.z += angle_difference(rotation_offset.z, target_rotation_offset.z) * delta * rotation_offset_speed

	position = player.head.get_global_transform_interpolated().origin
	rotation = player.head.global_rotation + rotation_offset


func _physics_process(_delta: float) -> void:
	head_velocity = (player.head.global_position - last_head_position) / get_physics_process_delta_time()
	last_head_position = player.head.global_position


func _on_state_machine_state_changed(last_state: StringName, _current_state: StringName) -> void:
	if last_state == &"Spawning":
		last_head_position = player.head.global_position
		head_velocity = Vector3.ZERO
		position = player.head.global_position
		rotation = player.head.global_rotation
		rotation_offset = Vector3.ZERO
		return
