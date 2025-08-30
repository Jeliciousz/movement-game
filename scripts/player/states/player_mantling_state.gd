class_name PlayerMantlingState
extends State
## Active while the [Player] is mantling.

## The [Player].
@export var _player: Player

var mantle_position: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	_player.mantle_ledge_raycast.force_raycast_update()
	var mantle_height: float = _player.mantle_ledge_raycast.target_position.length() - _player.mantle_ledge_raycast.get_collision_point().distance_to(_player.mantle_ledge_raycast.global_position)
	mantle_position = _player.position + _player.up_direction * mantle_height


func _state_physics_process(delta: float) -> void:
	update_stance()

	_player.position = _player.position.move_toward(mantle_position, delta * _player.mantle_speed)

	if _player.position.is_equal_approx(mantle_position):
		_player.position += _player.up_direction * _player.safe_margin
		_player.velocity = _player.get_forward_direction() * Vector2(shared_vars[&"mantle_velocity"].x, shared_vars[&"mantle_velocity"].z).length() * (1.0 - _player.mantle_speed_penalty)
		_player.velocity.y += maxf(shared_vars[&"mantle_velocity"].y, 0.0) * (1.0 - _player.mantle_speed_penalty)
		_player.velocity += _player.up_direction * _player.mantle_power

		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING
