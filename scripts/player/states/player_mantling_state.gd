class_name PlayerMantlingState
extends State
## Active while the [Player] is mantling.

## The [Player].
@export var _player: Player

var mantle_position: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	var normal: Vector3 = Vector3(_player.get_wall_normal().x, 0.0, _player.get_wall_normal().z).normalized()
	_player.mantle_ledge_raycast.position = Vector3(0.0, 2.5, 0.0) + _player.basis.inverse() * -normal * 0.65
	_player.mantle_ledge_raycast.force_raycast_update()
	mantle_position = _player.mantle_ledge_raycast.get_collision_point()


func _state_physics_process(delta: float) -> void:
	_player.position = _player.position.move_toward(mantle_position, delta * _player.mantle_speed)

	if _player.position.is_equal_approx(mantle_position):
		_player.position += _player.up_direction * _player.safe_margin
		_player.velocity = _player.mantle_velocity * (1.0 - _player.mantle_speed_penalty)

		if _player.velocity.y < 0.0:
			_player.velocity.y = 0.0

		_player.velocity += _player.up_direction * _player.mantle_power

		state_machine.change_state_to(&"Airborne")
		return
