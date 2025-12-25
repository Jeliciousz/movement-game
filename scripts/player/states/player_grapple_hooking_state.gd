class_name PlayerGrappleHookingState
extends State
## Active while the [Player] is grapple-hooking.

## The [Player].
@export var _player: Player


func _state_enter(_last_state_name: StringName) -> void:
	_player.active_grapple_hook_point.targeted = GrappleHookPoint.Target.NOT_TARGETED
	_player.coyote_jump_ready = false
	_player.coyote_slide_ready = false
	_player.coyote_wall_jump_ready = false

	_player.grapple_hook_line.show()
	_player.grapple_hook_line.position = _player.head.global_position + _player.head.global_basis.x * -0.2 + _player.head.global_basis.y * -0.2
	_player.grapple_hook_line.points[1] = _player.active_grapple_hook_point.position - _player.grapple_hook_line.position

	var direction_to_grapple: Vector3 = _player.get_center_of_mass().direction_to(_player.active_grapple_hook_point.position)
	_player.velocity += direction_to_grapple * _player.grapple_hook_speed


func _state_exit() -> void:
	_player.grapple_hook_line.hide()


func _state_process(_delta: float) -> void:
	_player.grapple_hook_line.position = _player.head.get_global_transform_interpolated().origin + _player.head.global_basis.x * -0.2 + _player.head.global_basis.y * -0.2
	_player.grapple_hook_line.points[1] = _player.active_grapple_hook_point.position - _player.grapple_hook_line.position


func _state_physics_preprocess(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if InputBuffer.is_action_buffered(&"grapple_hook"):
		InputBuffer.clear_buffered_action(&"grapple_hook")
		state_machine.change_state_to(&"Airborne")
		return


func _state_physics_process(_delta: float) -> void:
	update_stance()
	update_physics()
	_player.stair_step_up()
	_player.move()

	if _player.is_on_floor():
		_player.footstep_audio.play()
		state_machine.change_state_to(&"Grounded")
		return

	if _player.can_mantle():
		state_machine.change_state_to(&"Mantling")
		return

	if _player.can_start_wallrun():
		_player.start_wallrun()
		state_machine.change_state_to(&"WallRunning")
		return


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.SPRINTING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and _player.air_crouches < _player.air_crouch_limit:
				_player.air_crouches += 1
				_player.crouch()

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and _player.air_crouches < _player.air_crouch_limit:
				_player.air_crouches += 1
				_player.crouch()


func update_physics() -> void:
	var direction_from_grapple: Vector3 = _player.active_grapple_hook_point.position.direction_to(_player.get_center_of_mass())
	var distance_from_grapple: float = _player.active_grapple_hook_point.position.distance_to(_player.get_center_of_mass())
	var weight: float = clampf((distance_from_grapple - _player.grapple_hook_min_distance) / (_player.grapple_hook_max_distance - _player.standing_height), 0, 1)
	var power: float = lerpf(0, _player.grapple_hook_speed, weight)

	_player.velocity += -direction_from_grapple * maxf(0, _player.velocity.dot(direction_from_grapple))
	_player.velocity += -direction_from_grapple * maxf(0, (power - _player.velocity.dot(-direction_from_grapple)))

	_player.add_air_resistence()
	_player.add_gravity(_player.physics_gravity_multiplier)
	_player.add_movement(_player.air_speed, _player.air_acceleration)
