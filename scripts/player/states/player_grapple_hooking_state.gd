class_name PlayerGrappleHookingState
extends State
## Active while the [Player] is grapple-hooking.

## The [Player].
@export var _player: Player


func _state_enter() -> void:
	shared_vars[&"grapple_hook_point"].targeted = GrappleHookPoint.Target.NOT_TARGETED
	shared_vars[&"coyote_jump_active"] = false
	shared_vars[&"coyote_slide_active"] = false
	shared_vars[&"coyote_walljump_active"] = false

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
	_player.update()

	if _player.is_on_floor():
		_player.footstep_audio.play()
		state_machine.change_state_to(&"Grounded")
		return

	DebugDraw3D.draw_line(_player.get_center_of_mass(), shared_vars[&"grapple_hook_point"].position, Color.BLACK)


func update_stance() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	match _player.stance:
		Player.Stances.STANDING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.SPRINTING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
				_player.crouch()
				shared_vars[&"air_crouches"] += 1

		Player.Stances.CROUCHING:
			if not Input.is_action_pressed(&"crouch") or not _player.crouch_enabled:
				_player.attempt_uncrouch()

		Player.Stances.SPRINTING:
			if InputBuffer.is_action_buffered(&"sprint") and _player.sprint_enabled:
				InputBuffer.clear_buffered_action(&"sprint")
				_player.stance = Player.Stances.STANDING
				return

			if Input.is_action_just_pressed(&"crouch") and _player.air_crouch_enabled and shared_vars[&"air_crouches"] < _player.air_crouch_limit:
				_player.crouch()
				shared_vars[&"air_crouches"] += 1


func update_physics() -> void:
	_player.add_air_resistence(_player.physics_air_resistence)
	_player.add_gravity(_player.physics_gravity)
	_player.add_movement(_player.air_speed, _player.air_acceleration)

	var direction_from_grapple: Vector3 = shared_vars[&"grapple_hook_point"].position.direction_to(_player.get_center_of_mass())
	var distance_from_grapple: float = shared_vars[&"grapple_hook_point"].position.distance_to(_player.get_center_of_mass())
	var weight: float = clampf((distance_from_grapple - _player.standing_height) / (_player.grapple_hook_max_distance - _player.standing_height), 0, 1)
	var power: float = lerpf(0, _player.grapple_hook_power, weight)

	_player.velocity += -direction_from_grapple * maxf(0, _player.velocity.dot(direction_from_grapple))
	_player.velocity += -direction_from_grapple * maxf(0, (power - _player.velocity.dot(-direction_from_grapple)))
