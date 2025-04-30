class_name PlayerLedgeGrabbingState
extends State
## Active while the [Player] is ledge-grabbing.

## The [Player].
@export var _player: Player

var ledge_grab_position: Vector3 = Vector3.ZERO


func _state_enter() -> void:
	_player.ledge_grab_ledge_raycast.force_raycast_update()
	var ledge_grab_height: float = _player.ledge_grab_ledge_raycast.target_position.length() - _player.ledge_grab_ledge_raycast.get_collision_point().distance_to(_player.ledge_grab_ledge_raycast.global_position)
	ledge_grab_position = _player.position + _player.up_direction * ledge_grab_height


func _state_physics_process(delta: float) -> void:
	update_stance()

	_player.position = _player.position.move_toward(ledge_grab_position, delta * 15.0)

	if _player.position.is_equal_approx(ledge_grab_position):
		_player.velocity = _player.get_forward_direction() * Vector3(shared_vars[&"ledge_grab_velocity"].x, shared_vars[&"ledge_grab_velocity"].y * 0.5, shared_vars[&"ledge_grab_velocity"].z).length()
		_player.velocity.y = 8.0

		if InputBuffer.is_action_buffered(&"jump"):
			InputBuffer.clear_buffered_action(&"jump")
			_player.velocity += _player.get_forward_direction() * 4.0

		state_machine.change_state_to(&"Grounded")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING
