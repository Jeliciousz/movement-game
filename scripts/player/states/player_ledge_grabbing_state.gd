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

	_player.position = _player.position.move_toward(ledge_grab_position, delta * _player.ledge_grab_speed)

	if _player.position.is_equal_approx(ledge_grab_position):
		_player.position += _player.up_direction * _player.safe_margin
		_player.velocity = _player.get_forward_direction() * Vector3(shared_vars[&"ledge_grab_velocity"].x * _player.ledge_grab_horizontal_speed_followthrough, shared_vars[&"ledge_grab_velocity"].y * _player.ledge_grab_vertical_speed_followthrough, shared_vars[&"ledge_grab_velocity"].z * _player.ledge_grab_horizontal_speed_followthrough).length()
		_player.velocity += _player.up_direction * _player.ledge_grab_power

		if Input.is_action_pressed(&"jump"):
			InputBuffer.clear_buffered_action(&"jump")
			shared_vars[&"coyote_jump_active"] = false
			shared_vars[&"coyote_slide_active"] = false
			shared_vars[&"air_jumps"] = 0
			shared_vars[&"wall_jumps"] = 0
			_player.velocity += _player.up_direction * _player.ledge_grab_vault_power
			_player.velocity += _player.get_forward_direction() * _player.ledge_grab_vault_horizontal_power
			state_machine.change_state_to(&"Jumping")
			return

		state_machine.change_state_to(&"Airborne")
		return


func update_stance() -> void:
	match _player.stance:
		Player.Stances.STANDING:
			_player.stance = Player.Stances.SPRINTING

		Player.Stances.CROUCHING:
			if _player.attempt_uncrouch():
				_player.stance = Player.Stances.SPRINTING
