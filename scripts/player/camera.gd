class_name PlayerCamera
extends Camera3D
## Controls the [Player]'s camera. Accounts for per-frame rotation, with interpolated translation.
## Animates the camera based on the Player's state.

## The [Player].
@export var _player: Player
## How much a change in rotation is damped.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var rotation_velocity_damping: float = 60.0
## How quickly the rotation will zero-out.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var rotation_zeroing_acceleration: float = 250.0
## How much can the camera's rotation be offset.
@export_range(0, 89, 1, "radians_as_degrees") var rotation_max_offset: float = deg_to_rad(15.0)

var _target_position: Vector3 = Vector3.ZERO
var _target_rotation: Vector3 = Vector3.ZERO
var _rotation_offset: Vector3 = Vector3.ZERO
var _rotation_offset_velocity: Vector3 = Vector3.ZERO
var _head_velocity: Vector3 = Vector3.ZERO
var _last_head_position: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:
	_rotation_offset_velocity += -_rotation_offset_velocity * rotation_velocity_damping * delta
	_rotation_offset_velocity += (Vector3.ZERO - _rotation_offset) * rotation_zeroing_acceleration * delta

	match _player.state_machine.get_state_name():
		&"WallRunning":
			_rotation_offset_velocity += Vector3(0.0, 0.0, deg_to_rad(-1250.0) * _player.state_machine.shared_vars[&"wallrun_wall_normal"].dot(_player.basis.x)) * delta
		&"LedgeGrabbing":
			_rotation_offset_velocity += Vector3(deg_to_rad(-5000.0), 0.0, 0.0) * delta
		&"Sliding":
			_rotation_offset_velocity += Vector3(deg_to_rad(-50.0) * _head_velocity.dot(_player.basis.z), 0.0, deg_to_rad(150.0) * _head_velocity.dot(_player.basis.x)) * delta
		&"Jumping":
			_rotation_offset_velocity += Vector3(deg_to_rad(-100.0) + deg_to_rad(-100.0) * _head_velocity.dot(_player.basis.y), 0.0, deg_to_rad(-100.0) * _head_velocity.dot(_player.basis.x)) * delta
		_:
			_rotation_offset_velocity += Vector3(deg_to_rad(-100.0) * _head_velocity.dot(_player.basis.y), 0.0, deg_to_rad(-100.0) * _head_velocity.dot(_player.basis.x)) * delta

	_rotation_offset += _rotation_offset_velocity * delta

	_target_position = _player.head.get_global_transform_interpolated().origin
	_target_rotation = _player.head.global_rotation
	_target_rotation += _rotation_offset.clampf(-rotation_max_offset, rotation_max_offset)

	position = _target_position
	rotation = _target_rotation


func _physics_process(_delta: float) -> void:
	_head_velocity = (_player.head.global_position - _last_head_position) / get_physics_process_delta_time()
	_last_head_position = _player.head.global_position


func _on_state_machine_state_changed(_last_state: StringName, current_state: StringName) -> void:
	match current_state:
		&"LedgeGrabbing":
			_rotation_offset_velocity += Vector3(deg_to_rad(375.0), 0.0, 0.0)
			return
		&"Sliding":
			_rotation_offset_velocity += Vector3(deg_to_rad(250.0), 0.0, 0.0)
			return
		&"Jumping":
			_rotation_offset_velocity += Vector3(deg_to_rad(-125.0), 0.0, 0.0)
			return
		&"Spawning":
			_target_position = _player.head.global_position
			_target_rotation = _player.head.global_rotation
			_rotation_offset = Vector3.ZERO
			_rotation_offset_velocity = Vector3.ZERO
			_head_velocity = Vector3.ZERO
			_last_head_position = _player.head.global_position
			position = _target_position
			rotation = _target_rotation
			return
