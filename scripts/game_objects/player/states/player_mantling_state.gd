class_name PlayerMantlingState
extends State
## Active while the [Player] is mantling.

## The [Player].
@export var _player: Player

var mantle_position: Vector3 = Vector3.ZERO
var start_position: Vector3 = Vector3.ZERO
var mantle_t: float = 0.0


func _state_enter(_last_state_name: StringName) -> void:
	start_position = _player.position
	mantle_t = 0.0

	mantle_position = _player.mantle_ledge_raycast.get_collision_point()


func _state_physics_process(delta: float) -> void:
	mantle_t = clampf(mantle_t + delta * _player.mantle_speed, 0.0, 1.0)

	_player.position = start_position.lerp(mantle_position, ease(mantle_t, -2.0))

	if mantle_t == 1.0:
		_player.position = mantle_position
		_player.velocity.y = 0.0
		_player.apply_floor_snap()
		state_machine.change_state_to(&"Grounded")
		return
