extends Camera3D

@export var _player: Player

var _target_position: Vector3 = Vector3.ZERO
var _target_rotation: Vector3 = Vector3.ZERO
var _rotation_offset: Vector3 = Vector3.ZERO
var _rotation_offset_velocity: Vector3 = Vector3.ZERO
var _head_velocity: Vector3 = Vector3.ZERO
var _last_head_position: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:
	_rotation_offset_velocity += -_rotation_offset_velocity * 60.0 * delta
	_rotation_offset_velocity += (Vector3.ZERO - _rotation_offset) * 250.0 * delta

	match _player.state_machine.get_state_name():
		&"WallRunning":
			_rotation_offset_velocity += Vector3(0.0, 0.0, deg_to_rad(-5.0) * _player.state_machine._shared_vars[&"wallrun_wall_normal"].dot(_player.basis.x)) * 250.0 * delta
		&"LedgeGrabbing":
			_rotation_offset_velocity += Vector3(deg_to_rad(-20.0), 0.0, 0.0) * 250.0 * delta
		&"Sliding":
			_rotation_offset_velocity += Vector3(deg_to_rad(-0.2) * _head_velocity.dot(_player.basis.z), 0.0, deg_to_rad(0.6) * _head_velocity.dot(_player.basis.x)) * 250.0 * delta
		&"Jumping":
			_rotation_offset_velocity += Vector3(deg_to_rad(-0.4) + deg_to_rad(-0.4) * _head_velocity.dot(_player.basis.y), 0.0, deg_to_rad(-0.4) * _head_velocity.dot(_player.basis.x)) * 250.0 * delta
		_:
			_rotation_offset_velocity += Vector3(deg_to_rad(-0.4) * _head_velocity.dot(_player.basis.y), 0.0, deg_to_rad(-0.4) * _head_velocity.dot(_player.basis.x)) * 250.0 * delta

	_rotation_offset += _rotation_offset_velocity * delta

	_target_position = _player.head.get_global_transform_interpolated().origin
	_target_rotation = _player.head.global_rotation
	_target_rotation += _rotation_offset.clampf(deg_to_rad(-30.0), deg_to_rad(30.0))

	position = _target_position
	rotation = _target_rotation


func _physics_process(_delta: float) -> void:
	_head_velocity = (_player.head.global_position - _last_head_position) / get_physics_process_delta_time()
	_last_head_position = _player.head.global_position


func _on_state_machine_state_changed(_last_state: StringName, current_state: StringName) -> void:
	match current_state:
		&"LedgeGrabbing":
			_rotation_offset_velocity += Vector3(deg_to_rad(1.5), 0.0, 0.0) * 250.0
			return
		&"Sliding":
			_rotation_offset_velocity += Vector3(deg_to_rad(1.0), 0.0, 0.0) * 250.0
			return
		&"Jumping":
			_rotation_offset_velocity += Vector3(deg_to_rad(-0.5), 0.0, 0.0) * 250.0
			return
