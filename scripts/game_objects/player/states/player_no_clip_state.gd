class_name PlayerNoClipState
extends State
## Active while the [Player] is no-clipping.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.velocity = Vector3.ZERO
	_player.collision_shape.disabled = true


func _state_exit() -> void:
	_player.collision_shape.disabled = false


func _state_physics_actions(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if Input.is_action_just_pressed(&"no_clip"):
		state_machine.change_state_to(&"Airborne")


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.move_and_slide()


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint"):
				InputBuffer.clear_buffered_action(&"sprint")
				_player.change_stance(Player.Stances.SPRINTING)

		Player.Stances.CROUCHING:
			_player._uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint"):
				InputBuffer.clear_buffered_action(&"sprint")
				_player.change_stance(Player.Stances.STANDING)


func update_physics() -> void:
	var no_clip_speed: float = 8.0 if _player.stance == Player.Stances.STANDING else 25.0
	var direction: Vector3 = (_player.input_vector.x * _player.head.global_basis.x + _player.input_vector.y * _player.head.global_basis.z + Input.get_axis(&"crouch", &"jump") * _player.head.global_basis.y).normalized()
	_player.velocity = no_clip_speed * direction
