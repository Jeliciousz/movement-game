class_name PlayerCamera
extends Camera3D
## Controls the [Player]'s camera. Accounts for per-frame rotation, with interpolated translation.
## Animates the camera based on the Player's state.

## The [Player].
@export var _player: Player
## How quickly the camera rotates.
@export var rotation_offset_speed: float = 10.0
## How much the player's velocity influences the camera rotation.
@export var rotation_offset_velocity_influence: float = 0.5
## How much the camera is tilted away from a wall the player is running on.
@export var rotation_offset_wallrun_influence: float = 5.0
## How much the camera is tilted upwards when sliding.
@export var rotation_offset_slide_pitch_influence: float = 5.0
## How much the camera is rolled when sliding sideways.
@export var rotation_offset_slide_roll_influence: float = 1.0
## How quickly the camera goes back down after starting a slide.
@export var rotation_offset_slide_return_speed: float = 2.0
## How much the camera is tilted up while ledge grabbing.
@export var rotation_offset_ledge_grab_influence: float = 15.0

var _rotation_offset: Vector3 = Vector3.ZERO
var _head_velocity: Vector3 = Vector3.ZERO
var _last_head_position: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:
	var target_rotation_offset: Vector3 = -Vector3(deg_to_rad(rotation_offset_velocity_influence) * _head_velocity.dot(_player.basis.y), 0.0, deg_to_rad(rotation_offset_velocity_influence) * _head_velocity.dot(_player.basis.x))

	match _player.state_machine.get_state_name():
		&"WallRunning":
			target_rotation_offset.z -= deg_to_rad(rotation_offset_wallrun_influence) * _player.wall_run_normal.dot(_player.basis.x)
		&"Sliding":
			var slide_time: float = float(Global.time - _player.slide_timestamp) / float(_player.slide_duration)
			target_rotation_offset += Vector3(deg_to_rad(rotation_offset_slide_pitch_influence) * maxf(1.0 - slide_time * rotation_offset_slide_return_speed, 0.0), 0.0, deg_to_rad(rotation_offset_slide_roll_influence) * _head_velocity.dot(_player.basis.x))
		&"LedgeGrabbing":
			target_rotation_offset += Vector3(deg_to_rad(rotation_offset_ledge_grab_influence), 0.0, 0.0)

	_rotation_offset.x += angle_difference(_rotation_offset.x, target_rotation_offset.x) * delta * rotation_offset_speed
	_rotation_offset.y += angle_difference(_rotation_offset.y, target_rotation_offset.y) * delta * rotation_offset_speed
	_rotation_offset.z += angle_difference(_rotation_offset.z, target_rotation_offset.z) * delta * rotation_offset_speed

	position = _player.head.get_global_transform_interpolated().origin
	rotation = _player.head.global_rotation + _rotation_offset


func _physics_process(_delta: float) -> void:
	_head_velocity = (_player.head.global_position - _last_head_position) / get_physics_process_delta_time()
	_last_head_position = _player.head.global_position


func _on_state_machine_state_changed(last_state: StringName, _current_state: StringName) -> void:
	if last_state == &"Spawning":
		_last_head_position = _player.head.global_position
		_head_velocity = Vector3.ZERO
		position = _player.head.global_position
		rotation = _player.head.global_rotation
		_rotation_offset = Vector3.ZERO
		return
