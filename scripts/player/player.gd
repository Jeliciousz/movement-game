class_name Player
extends CharacterBody3D
## The Player controller.


## Different states a player can be in.
enum Stances {
	STANDING,
	CROUCHING,
	SPRINTING,
}


## Sets the player's stance and updates the last_stance variable.
func set_stance(value: Stances) -> void:
	if value != stance:
		last_stance = stance
		stance = value


## Gets the player's stance as a string.
func get_stance_as_text() -> String:
	match stance:
		Stances.STANDING:
			return "Standing"

		Stances.CROUCHING:
			return "Crouching"

		Stances.SPRINTING:
			return "Sprinting"

	return ""


##################################################
# Exports
##################################################


@export_group("Physics", "physics_")

## The acceleration applied against the direction of the player's velocity while on the ground.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var physics_friction: float = 25.0

## The acceleration applied opposite and proportional to the player's velocity.
@export_range(0.0, 1.0, 0.001, "suffix:m/s/s") var physics_air_resistence: float = 0.025

## How much gravity is applied to the player.
@export_range(0.0, 1.0, 0.05, "suffix:×") var physics_gravity_multiplier: float = 1.0


@export_group("Coyote Time", "coyote_")

## Is there coyote time for jumps?
@export var coyote_jump_enabled: bool = true

## Is there coyote time for slides?
@export var coyote_slide_enabled: bool = true

## Is there coyote time for slide jumps?
@export var coyote_slide_jump_enabled: bool = true

## Is there coyote time for walljumps?
@export var coyote_walljump_enabled: bool = true

## How many realtime milliseconds coyote time lasts.
@export_range(0, 1000, 10, "suffix:ms") var coyote_duration: int = 100


@export_group("Stepping", "step_")

## Can the player step up and down stairs?
@export var step_enabled: bool = true

## Maximum height the player can step up.
@export_range(0.0, 1.0, 0.05, "suffix:m") var step_up_max: float = 0.5

## Maximum height the player can step down.
@export_range(0.0, 1.0, 0.05, "suffix:m") var step_down_max: float = -0.5


@export_group("Movement", "move_")

## How fast the player can move.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var move_speed: float = 4.0

## How quickly the player accelerates.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var move_acceleration: float = 60.0

## How quickly the player can move backwards relative to base speed.
@export_range(0.0, 1.0, 0.05, "suffix:×") var move_backwards_multiplier: float = 0.9

## How much friction is reduced when going against the wish direction of the player.
@export_range(0.0, 1.0, 0.05, "suffix:×") var move_friction_multiplier: float = 0.75


@export_subgroup("Air Control", "air_")

## How fast the player can move in the air.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var air_speed: float = 1.0

## How quickly the player accelerates in the air.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var air_acceleration: float = 30.0


@export_group("Jumping", "jump_")

## Can the player jump?
@export var jump_enabled: bool = true

## How high the player jumps.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var jump_impulse: float = 8.0

## How far the player jumps.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var jump_horizontal_impulse: float = 1.25

## How high the player jumps while standing still.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var jump_standing_impulse: float = 9.0

## How long the player can jump for.
@export_range(0.0, 1.0, 0.005, "suffix:s") var jump_duration: float = 0.35

## How much gravity is applied while the player is jumping.
@export_range(0.0, 1.0, 0.05, "suffix:×") var jump_gravity_multiplier: float = 0.8


@export_subgroup("Proportional Jump Power", "proportional_jump_")

## Is proportional jump power enabled?
@export var proportional_jump_enabled: bool = true

## The base speed of proportional jump power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var proportional_jump_base_speed: float = 4.0

## The top speed of proportional jump power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var proportional_jump_top_speed: float = 8.0

## How high the player jumps at top speed.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var proportional_jump_top_impulse: float = 10.0

## How far the player jumps at top speed.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var proportional_jump_top_horizontal_impulse: float = 0.25


@export_subgroup("Air-Jumping", "air_jump_")

## Can the player air jump?
@export var air_jump_enabled: bool = false

## How high the player air jumps.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var air_jump_impulse: float = 8.0

## How far the player air jumps.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var air_jump_horizontal_impulse: float = 8.0

## How high the player air jumps when not jumping in any direction.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var air_jump_standing_impulse: float = 9.0

## How many times the player can air jump before touching the ground.
@export_range(0, 100, 1) var air_jump_limit: int = 1


@export_group("Sprinting", "sprint_")

## Can the player sprint?
@export var sprint_enabled: bool = true

## How fast the player can move while sprinting.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var sprint_speed: float = 7.0

## How quickly the player accelerates while sprinting.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var sprint_acceleration: float = 120.0


@export_group("Crouching", "crouch_")

## Can the player crouch?
@export var crouch_enabled: bool = true

## How short the player is while crouching.
@export_range(0.0, 1.0, 0.05, "suffix:×") var crouch_height_multiplier: float = 0.5

## How fast the player can move while crouching.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var crouch_speed: float = 2.0

## How quickly the player accelerates while crouching.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var crouch_acceleration: float = 60.0

## The time it takes for the player's view to move down to crouch or up to uncrouch.
@export_range(0.0, 1.0, 0.005, "suffix:s") var crouch_tween_duration: float = 0.1


@export_subgroup("Crouch-Jumping", "crouch_jump_")

## Can the player jump while crouching?
@export var crouch_jump_enabled: bool = true

## How long after crouching can the player still jump?[br]
## 0 = The player can always jump while crouching.
@export_range(0.0, 1.0, 0.005, "suffix:s") var crouch_jump_window: float = 0.2


@export_subgroup("Air-Crouching", "air_crouch_")

## Can the player crouch in the air?
@export var air_crouch_enabled: bool = false

## How many times the player can crouch in the air before touching the ground.
@export_range(0, 100, 1) var air_crouch_limit: int = 1


@export_group("Sliding", "slide_")

## Can the player slide?
@export var slide_enabled: bool = true

## How fast the player slides at the slowest.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_speed: float = 10.0

## How quickly the player accelerates (to change direction of velocity) while sliding.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var slide_acceleration: float = 16.0

## How much friction is applied while sliding.
@export_range(0.0, 1.0, 0.05, "suffix:×") var slide_friction_multiplier: float = 0.125

## How fast the player must be moving to slide.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_start_speed: float = 6.5

## How fast the player must be to stay sliding.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_stop_speed: float = 7.0

## How long the player must wait after sliding until they can slide again.
@export_range(0.0, 1.0, 0.005, "suffix:s") var slide_cooldown: float = 0.25


@export_subgroup("Slide-Canceling", "slide_cancel_")

## Can the player slide cancel?
@export var slide_cancel_enabled: bool = true

## How long the player must wait after starting to slide until they can slide cancel.
@export_range(0.0, 1.0, 0.005, "suffix:s") var slide_cancel_delay: float = 0.2

## How much the player is slowed when they slide cancel.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_cancel_impulse: float = 5.0


@export_subgroup("Slide-Jumping", "slide_jump_")

## Can the player slide jump?
@export var slide_jump_enabled: bool = true

## How high the player jumps while sliding.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_jump_impulse: float = 18.0

## How far the player jumps in the direction they're moving while sliding.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_jump_horizontal_impulse: float = -7.0

## How long the player must wait after starting a slide until they can slide jump.
@export_range(0.0, 1.0, 0.005, "suffix:s") var slide_jump_delay: float = 0.25


@export_subgroup("Ledge-Jumping", "ledge_jump_")

## Can the player ledge jump?
@export var ledge_jump_enabled: bool = true

## How high the player ledge jumps.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var ledge_jump_impulse: float = 10.0

## How far the player ledge jumps in the direction they're moving.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var ledge_jump_horizontal_impulse: float = 2.5

## How long after sliding off a ledge can the player ledge jump.
@export_range(0.0, 1.0, 0.005, "suffix:s") var ledge_jump_window: float = 0.25


@export_subgroup("Wall-Jumping", "walljump_")

## Can the player wall-jump?
@export var walljump_enabled: bool = true

## How many times the player can wall-jump with full power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var walljump_min_limit: int = 4

## How many wall-jumps until the player has no wall-jump power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var walljump_max_limit: int = 8

## How high the player jumps while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var walljump_impulse: float = 9.0

## How far the player jumps forwards while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var walljump_forward_impulse: float = -4.5

## How far the player jumps away from the wall while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var walljump_normal_impulse: float = 10.0


@export_group("Wall-Running", "wallrun_")

## Can the player wall-run?
@export var wallrun_enabled: bool = true

## The fast the player can move while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wallrun_speed: float = 8.0

## How quickly the player accelerates while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wallrun_acceleration: float = 80.0

## How long the player can wall-run until they start sliding.
@export_range(0.0, 1.0, 0.005, "suffix:s") var wallrun_duration: float = 0.1

## How fast the player must be to start wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wallrun_start_speed: float = 5.5

## How fast the player must be until they stop wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wallrun_stop_speed: float = 2.0

## How much gravity is applied while sliding on a wall.
@export_range(0.0, 1.0, 0.05, "suffix:×") var wallrun_gravity_multiplier: float = 0.5

## How much friction is applied horizontally while sliding on a wall.
@export_range(0.0, 1.0, 0.05, "suffix:×") var wallrun_friction_multiplier: float = 0.3

## The acceleration opposing upwards movement while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wallrun_upwards_friction: float = 20.0

## The acceleration opposing downwards movement while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wallrun_downwards_friction: float = 90.0

## How hard the player is pushed from a wall when they cancel a wall-run.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wallrun_cancel_impulse: float = 2.0

## How long the player must wait after a wallrun until they can wall-run again.
@export_range(0.0, 1.0, 0.005, "suffix:s") var wallrun_cooldown: float = 0.25

## The angle into a wall the player must be moving at to start wall-running.
@export_range(0.0, 90.0, 1.0, "radians_as_degrees") var wallrun_min_start_angle: float = deg_to_rad(5.0)

## The largest external angle a wall can have for the player to stay running on it.
@export_range(0.0, 90.0, 1.0, "radians_as_degrees") var wallrun_max_external_angle: float = deg_to_rad(15.0)

## The largest internal angle a wall can have for the player to stay running on it.
@export_range(0.0, 90.0, 1.0, "radians_as_degrees") var wallrun_max_internal_angle: float = deg_to_rad(45.0)


@export_group("Mantling", "mantle_")

## Can the player mantle?
@export var mantle_enabled: bool = true

## How quickly the player mantles over a ledge.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var mantle_speed: float = 6.0

## How much of the player's speed is lost when they mantle.
@export_range(0.0, 1.0, 0.05, "suffix:×") var mantle_speed_penalty: float = 0.1

## The angle into a ledge the player must be wishing to move at to mantle.
@export_range(0.0, 90.0, 1.0, "radians_as_degrees") var mantle_max_wish_angle: float = deg_to_rad(60.0)



@export_group("Grapple Hooking", "grapplehook_")

## Can the player grapple hook?
@export var grapplehook_enabled: bool = true

## How fast the player is pulled towards the grapple point when grapple hooking.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var grapplehook_speed: float = 6.0

## How far from the grapple point the player must be to grapple to it.
@export_range(0.0, 50.0, 0.05, "suffix:m") var grapplehook_min_distance: float = 7.0

## How close to the grapple point the player must be to grapple to it.
@export_range(0.0, 50.0, 0.05, "suffix:m") var grapplehook_max_distance: float = 14.0


##################################################
# State Variables
##################################################


var stance: Stances = Stances.STANDING:
	set = set_stance

var last_stance: Stances = Stances.STANDING

var wish_direction: Vector3 = Vector3.ZERO
var input_vector: Vector2 = Vector2.ZERO

var coyote_engine_timestamp: int = 0

var crouch_timestamp: float = 0.0
var airborne_timestamp: float = 0.0
var jump_timestamp: float = 0.0
var slide_timestamp: float = 0.0
var wallrun_timestamp: float = 0.0

var air_crouching: bool = false
var coyote_jump_ready: bool = false
var coyote_slide_ready: bool = false
var coyote_slide_jump_ready: bool = false
var coyote_walljump_ready: bool = false
var ledge_jump_ready: bool = false
var is_grapplehook_point_in_range: bool = false

var air_jumps: int = Global.MAX_INT
var air_crouches: int = Global.MAX_INT
var walljumps: int = 0

var wallrun_normal: Vector3 = Vector3.ZERO
var wallrun_direction: Vector3 = Vector3.ZERO

var velocity_before_move: Vector3 = Vector3.ZERO

var active_grapplehook_point: GrappleHookPoint = null

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")


##################################################
# Child References
##################################################


@onready var head: Node3D = $Head
@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var health_component: HealthComponent = $HealthComponent
@onready var grapplehook_raycast: RayCast3D = $Head/Camera/GrappleHookRaycast
@onready var grapplehook_line: Line3D = $Head/Camera/GrappleHookRaycast/GrappleHookLine
@onready var wallrun_foot_raycast: RayCast3D = $WallrunFootRaycast
@onready var wallrun_hand_raycast: RayCast3D = $WallrunHandRaycast
@onready var wallrun_floor_raycast: RayCast3D = $WallrunFloorRaycast
@onready var mantle_foot_raycast: RayCast3D = $MantleFootRaycast
@onready var mantle_hand_raycast: RayCast3D = $MantleHandRaycast
@onready var mantle_head_raycast: RayCast3D = $MantleHeadRaycast
@onready var mantle_ledge_raycast: RayCast3D = $MantleLedgeRaycast
@onready var standing_height: float = collision_shape.shape.height
@onready var standing_head_y: float = head.position.y
@onready var grounded_uncrouch_area: Area3D = $GroundedUncrouchArea
@onready var airborne_uncrouch_area: Area3D = $AirborneUncrouchArea
@onready var footstep_audio: AudioStreamPlayer3D = $FootstepAudio
@onready var slide_audio: AudioStreamPlayer3D = $SlideAudio
@onready var grapplehook_fire_audio: AudioStreamPlayer3D = $GrappleHookFireAudio
@onready var grapplehook_indicator_audio: AudioStreamPlayer = $GrappleHookIndicatorAudio


##################################################
# Inherited Functions
##################################################


func _physics_process(_delta: float) -> void:
	wish_direction = basis * Vector3(input_vector.x, 0.0, input_vector.y).normalized()


func _unhandled_key_input(event: InputEvent) -> void:
	#	I didn't want to use Input.get_vector(...), because when opposing movement keys are pressed at the same time, it treats it as if the player hasn't pressed anything at all
	#
	#	What usually is happening when opposing movement keys are pressed at the same time, is that the player is switching between either key rapidly
	#	This happens a lot in fast-paced games
	#	But when opposing movement keys cancel each other out, it makes the player stand still in the small amount of time between pushing the new key, and releasing the old key
	#	This is the opposite of what the player wants: to keep moving
	#
	#	To fix this, I wrote it so that new inputs overwrite the previous ones, instead of canceling them out
	#	Then when the new input is released, it'll go back to the old input if it's still pressed, and only if it isn't, will it go to 0
	#
	#	This is called "Null-Canceling Movement", a concept I borrowed from a TF2 script, similar to Razer's snap tap, but I designed this code myself
	#
	#	-Jeliciousz

	if event.echo:
		return

	if event.is_action(&"move_forward"):
		if event.pressed:
			input_vector.y = -1.0
		else:
			input_vector.y = 1.0 if Input.is_action_pressed(&"move_back") else 0.0

	elif event.is_action(&"move_back"):
		if event.pressed:
			input_vector.y = 1.0
		else:
			input_vector.y = -1.0 if Input.is_action_pressed(&"move_forward") else 0.0

	elif event.is_action(&"move_left"):
		if event.pressed:
			input_vector.x = -1.0
		else:
			input_vector.x = 1.0 if Input.is_action_pressed(&"move_right") else 0.0

	elif event.is_action(&"move_right"):
		if event.pressed:
			input_vector.x = 1.0
		else:
			input_vector.x = -1.0 if Input.is_action_pressed(&"move_left") else 0.0


##################################################
# Getter Functions
##################################################


## Returns how much the player is moving backwards.
##
## 0: Player is strafing or moving forwards[br]
## 0 - 1: Player is moving diagonally backwards[br]
## 1: Player is moving directly backwards
func get_amount_moving_backwards() -> float:
	return maxf(0.0, wish_direction.dot(basis.z))


## Returns the forward direction of the player.
func get_forward_direction() -> Vector3:
	return -basis.z


## Returns the looking direction of the player.
func get_looking_direction() -> Vector3:
	return -head.global_basis.z


## Returns the vertical velocity of the player.
func get_vertical_velocity() -> Vector3:
	return Vector3(0.0, velocity.y, 0.0)


## Returns the horizontal velocity of the player.
func get_horizontal_velocity() -> Vector3:
	return Vector3(velocity.x, 0.0, velocity.z)


## Returns the speed of the player.
func get_speed() -> float:
	return velocity.length()


## Returns the horizontal speed of the player.
func get_horizontal_speed() -> float:
	return Vector2(velocity.x, velocity.z).length()


## Returns the direction of the velocity of the player.
func get_direction_of_velocity() -> Vector3:
	return velocity.normalized()


## Returns the direction of the horizontal velocity of the player.
func get_direction_of_horizontal_velocity() -> Vector3:
	return get_horizontal_velocity().normalized()


## Returns what the vertical velocity of the player was before moving.
func get_vertical_velocity_before_move() -> Vector3:
	return Vector3(0.0, velocity_before_move.y, 0.0)


## Returns what the horizontal velocity of the player was before moving.
func get_horizontal_velocity_before_move() -> Vector3:
	return Vector3(velocity_before_move.x, 0.0, velocity_before_move.z)



## Returns what the speed of the player was before moving.
func get_speed_before_move() -> float:
	return velocity_before_move.length()


## Returns what the horizontal speed of the player was before moving.
func get_horizontal_speed_before_move() -> float:
	return Vector2(velocity_before_move.x, velocity_before_move.z).length()


## Returns what the direction of the velocity of the player was before moving.
func get_direction_of_velocity_before_move() -> Vector3:
	return velocity_before_move.normalized()


## Returns what the direction of the horizontal velocity of the player was before moving.
func get_direction_of_horizontal_velocity_before_move() -> Vector3:
	return get_horizontal_velocity_before_move().normalized()


## Returns the player's center of mass.
func get_center_of_mass() -> Vector3:
	return collision_shape.global_position


##################################################
# Player Functions
##################################################


func move() -> void:
	velocity_before_move = velocity

	move_and_slide()

	# Is set to 0.0 when stepping up, so resetting after moving is necessary
	floor_snap_length = 0.5


func stair_step_down() -> bool:
	if not step_enabled:
		return false

	if velocity.y > 0.1:
		return false

	var collision: KinematicCollision3D = move_and_collide(Vector3(0.0, step_down_max, 0.0), true)

	if not collision:
		return false

	position.y += collision.get_travel().y
	apply_floor_snap()
	return true


func stair_step_up() -> void:
	if not step_enabled:
		return

	var motion: Vector3 = get_horizontal_velocity() * get_physics_process_delta_time()
	if motion.is_zero_approx():
		return

	_check_step_up(motion)


func _check_step_up(motion: Vector3) -> void:
	var transform_before_test: Transform3D = global_transform
	var collision: KinematicCollision3D = move_and_collide(motion)

	if not collision:
		global_transform = transform_before_test
		return

	# Return if colliding into slope, not wall
	var surface_normal: Vector3 = collision.get_normal()
	if surface_normal.angle_to(Vector3.UP) <= floor_max_angle:
		global_transform = transform_before_test
		return

	var remainder: Vector3 = collision.get_remainder()

	# Then move up a step (or into a ceiling)
	var step_up: Vector3 = step_up_max * Vector3.UP
	collision = move_and_collide(step_up)

	var step_up_travel: Vector3
	if collision:
		step_up_travel = collision.get_travel()
	else:
		step_up_travel = step_up

	# Move ahead a small amount to properly catch the step
	collision = move_and_collide(motion.normalized() * 0.05)

	# Project remaining along wall normal (if any)
	# So you can walk into wall and up a step
	if collision:
		var slide_remainder: Vector3 = collision.get_remainder()

		var wall_normal: Vector3 = collision.get_normal()
		var dot: float = slide_remainder.normalized().dot(-wall_normal)
		var projected_vector: Vector3 = slide_remainder + wall_normal * dot * slide_remainder.length()

		move_and_collide(projected_vector)

	# Move down onto step
	collision = move_and_collide(-step_up_travel)

	if collision:
		# Check floor normal for un-walkable slope
		surface_normal = collision.get_normal()
		if surface_normal.angle_to(Vector3.UP) > floor_max_angle:
			global_transform = transform_before_test
			return

	if absf(global_transform.origin.y - transform_before_test.origin.y) < 0.01:
		global_transform = transform_before_test
		return

	# Step up
	global_transform.origin.x = transform_before_test.origin.x
	global_transform.origin.z = transform_before_test.origin.z

	# This is necessary so the player doesn't get teleported back down during move_and_slide()
	floor_snap_length = 0.0

	velocity.y = 0.0

	# Recurse to step up many steps at once
	_check_step_up(remainder)


## Check if the player's next to (nearly colliding with) a surface in [param direction]. (Updates the player's [method CharacterBody3D.is_on_floor], [method CharacterBody3D.is_on_wall], and [method CharacterBody3D.is_on_ceiling] checks)
func check_surface(direction: Vector3) -> bool:
	var position_before_check: Vector3 = position
	var velocity_before_check: Vector3 = velocity

	velocity = direction.normalized() * safe_margin * 2.0 / get_physics_process_delta_time()

	var collided: bool = move_and_slide()

	position = position_before_check
	velocity = velocity_before_check

	return collided


func attempt_uncrouch() -> bool:
	if stance != Stances.CROUCHING:
		return true

	if air_crouching:
		airborne_uncrouch_area.position.y = -standing_height * (1.0 - crouch_height_multiplier)

		if not airborne_uncrouch_area.has_overlapping_bodies():
			_uncrouch()

			position.y -= standing_height * (1.0 - crouch_height_multiplier)
			air_crouching = false

			return true

	if not grounded_uncrouch_area.has_overlapping_bodies():
		_uncrouch()

		if air_crouching:
			air_crouching = false

		return true

	return false


func crouch() -> void:
	if stance == Stances.CROUCHING:
		return

	set_stance(Stances.CROUCHING)

	crouch_timestamp = Global.time

	head.start_crouch_tween(standing_head_y - standing_height * (1.0 - crouch_height_multiplier), crouch_tween_duration)

	collision_shape.shape.height = standing_height * crouch_height_multiplier
	collision_shape.position.y = (standing_height * crouch_height_multiplier) / 2.0

	wallrun_hand_raycast.position.y -= standing_height * (1.0 - crouch_height_multiplier)
	mantle_hand_raycast.position.y -= standing_height * (1.0 - crouch_height_multiplier)
	mantle_head_raycast.position.y -= standing_height * (1.0 - crouch_height_multiplier)
	mantle_head_raycast.target_position.y = mantle_hand_raycast.position.y
	mantle_ledge_raycast.position.y = mantle_hand_raycast.position.y
	mantle_ledge_raycast.target_position.y = -mantle_hand_raycast.position.y

	if is_on_floor():
		air_crouching = false
	else:
		position.y += standing_height * (1.0 - crouch_height_multiplier)
		air_crouching = true


func _uncrouch() -> void:
	if stance != Stances.CROUCHING:
		return

	set_stance(last_stance)

	crouch_timestamp = Global.time

	head.start_uncrouch_tween(standing_head_y, crouch_tween_duration)

	collision_shape.shape.height = standing_height
	collision_shape.position.y = standing_height / 2.0

	wallrun_hand_raycast.position.y += standing_height * (1.0 - crouch_height_multiplier)
	mantle_hand_raycast.position.y += standing_height * (1.0 - crouch_height_multiplier)
	mantle_head_raycast.position.y += standing_height * (1.0 - crouch_height_multiplier)
	mantle_head_raycast.target_position.y = mantle_hand_raycast.position.y
	mantle_ledge_raycast.position.y = mantle_hand_raycast.position.y
	mantle_ledge_raycast.target_position.y = -mantle_hand_raycast.position.y


func add_air_resistence() -> void:
	velocity = velocity.move_toward(Vector3.ZERO, physics_air_resistence * get_speed() * get_physics_process_delta_time())


func add_friction(friction: float, top_speed: float) -> void:
	var friction_direction: Vector3 = -get_direction_of_velocity()

	# When friction direction and movement direction oppose each other, dot product = -1, +1 = 0
	# Clamp between 0 and 1 to not apply more friction when friction direction aligns with movement direction
	var friction_product: float = minf(friction_direction.dot(wish_direction) + 1.0, 1.0)

	# If player is faster than the top speed they can move at, it will always apply friction. A reduced amount if going against the movement direction
	if get_speed() > top_speed:
		var scaled_friction_product: float = lerpf(move_friction_multiplier, 1, friction_product)

		velocity = velocity.move_toward(velocity.limit_length(top_speed), friction * get_physics_process_delta_time() * scaled_friction_product)
		return

	# Otherwise, it only applies friction if it doesn't go against the movement direction

	velocity = velocity.move_toward(Vector3.ZERO, friction * friction_product * get_physics_process_delta_time())


func add_wallrun_friction() -> void:
	if velocity.y < 0:
		velocity = velocity.move_toward(get_horizontal_velocity(), wallrun_downwards_friction * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(get_horizontal_velocity(), wallrun_upwards_friction * get_physics_process_delta_time())


func add_gravity(gravity_multiplier: float) -> void:
	velocity += gravity_vector * gravity * gravity_multiplier * get_physics_process_delta_time()


func slide_down_slopes() -> void:
	var dot: float = gravity_vector.dot(-get_floor_normal())
	var slope_acceleration: Vector3 = gravity_vector * gravity + get_floor_normal() * dot * gravity

	velocity += slope_acceleration * get_physics_process_delta_time()


func add_movement(top_speed: float, acceleration: float) -> void:
	#	This seemingly overcomplicated movement code is the result of trying to achieve movement that doesn't feel clunky or finnicky, and has good control,
	#	while still limiting the horizontal speed that the player can reach on their own
	#
	#	If it just checked if the player was slower than the top speed, then added to player's velocity if they were, then the player would have no control once they reached top speed,
	#	because any movement inputs would be ignored (also, the player's speed could be slightly off from top speed). The player would have to slow down to start moving in a different direction
	#
	#	If it didn't ignore movement inputs, but instead, added to the player's velocity, then just limited the speed to the top speed, the player WOULD be able to control their movement at top speed,
	#	but they WOULDN'T be able to ever go past that speed.
	#	External forces would be capped to the player's top speed, the player wouldn't be able to increase their speed by jumping, etc.
	#
	#	What I did, was make it so that if the player's new speed after applying the movement acceleration was faster than their than their old speed, and faster than top speed, it would limit it in two ways:
	#	If the player's old speed before applying the movement acceleration was SLOWER than the top speed, then it would limit their speed to the top speed
	#	But, if the player's old speed was already FASTER than the top speed, it would just limit it to the old speed
	#
	#	Notice that it doesn't just reset the velocity to what it was before applying the movement acceleration, it LIMITS it to the same speed,
	#	because the player isn't just moving in the same direction that they're already going.
	#	If the player moves perpendicular to the direction they're already going, it will change the direction of their velocity, while keeping the same speed
	#
	#	-Jeliciousz

	var backwards_multiplier: float = lerpf(1.0, move_backwards_multiplier, get_amount_moving_backwards())

	var old_horizontal_speed: float = get_horizontal_speed()
	velocity += wish_direction * acceleration * backwards_multiplier * get_physics_process_delta_time()
	var new_horizontal_speed: float = get_horizontal_speed()

	if new_horizontal_speed <= old_horizontal_speed:
		return

	if new_horizontal_speed <= top_speed * backwards_multiplier:
		return

	var limited_velocity: Vector3

	if old_horizontal_speed <= top_speed * backwards_multiplier:
		limited_velocity = get_horizontal_velocity().limit_length(top_speed * backwards_multiplier)
	else:
		limited_velocity = get_horizontal_velocity().limit_length(old_horizontal_speed)

	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.z


func jump() -> void:
	attempt_uncrouch()

	var effective_impulse: float = lerpf(jump_standing_impulse, jump_impulse, wish_direction.length())
	var effective_horizontal_impulse: float = jump_horizontal_impulse

	if proportional_jump_enabled:
		var proportional_jump_weight: float = clampf((get_horizontal_speed() - proportional_jump_base_speed) / (proportional_jump_top_speed - proportional_jump_base_speed), 0.0, 1.0)

		effective_impulse = lerpf(effective_impulse, proportional_jump_top_impulse, proportional_jump_weight)
		effective_horizontal_impulse = lerpf(effective_horizontal_impulse, proportional_jump_top_horizontal_impulse, proportional_jump_weight)

	velocity.y += effective_impulse
	velocity += wish_direction * effective_horizontal_impulse


func coyote_jump() -> void:
	attempt_uncrouch()

	var effective_impulse: float = lerpf(jump_standing_impulse, jump_impulse, wish_direction.length())
	var effective_horizontal_impulse: float = jump_horizontal_impulse

	if proportional_jump_enabled:
		var proportional_jump_weight: float = clampf((get_horizontal_speed() - proportional_jump_base_speed) / (proportional_jump_top_speed - proportional_jump_base_speed), 0.0, 1.0)

		effective_impulse = lerpf(effective_impulse, proportional_jump_top_impulse, proportional_jump_weight)
		effective_horizontal_impulse = lerpf(effective_horizontal_impulse, proportional_jump_top_horizontal_impulse, proportional_jump_weight)

	velocity.y = effective_impulse
	velocity += wish_direction * effective_horizontal_impulse


func air_jump() -> void:
	air_jumps += 1
	attempt_uncrouch()

	velocity = Vector3.ZERO

	var effective_impulse: float = lerpf(air_jump_standing_impulse, air_jump_impulse, wish_direction.length())

	velocity.y += effective_impulse
	velocity += wish_direction * air_jump_horizontal_impulse


func slide() -> void:
	crouch()

	velocity.y = 0.0

	if get_speed() < slide_speed:
		velocity = wish_direction * slide_speed


func slide_cancel() -> void:
	velocity -= get_direction_of_velocity() * slide_cancel_impulse


func slide_jump() -> void:
	attempt_uncrouch()

	velocity.y += slide_jump_impulse
	velocity += get_direction_of_velocity() * slide_jump_horizontal_impulse


func ledge_jump() -> void:
	attempt_uncrouch()

	velocity.y = ledge_jump_impulse
	velocity += wish_direction * ledge_jump_horizontal_impulse


func coyote_slide() -> void:
	coyote_slide_ready = false
	velocity.y = 0.0

	if get_speed() < slide_speed:
		velocity = wish_direction * slide_speed


func walljump(direction: Vector3) -> void:
	walljumps += 1

	var effective_impulse: float

	if walljumps == walljump_max_limit:
		effective_impulse = 0.0
	elif walljumps > walljump_min_limit:
		effective_impulse = lerpf(walljump_impulse, 0.0, float(walljumps - walljump_min_limit) / float(walljump_max_limit - walljump_min_limit))
	else:
		effective_impulse = walljump_impulse

	velocity.y = effective_impulse
	velocity += direction * walljump_forward_impulse
	velocity += wallrun_normal * walljump_normal_impulse


func coyote_walljump(direction: Vector3) -> void:
	velocity -= wallrun_normal * wallrun_cancel_impulse
	walljumps += 1

	var effective_impulse: float

	if walljumps == walljump_max_limit:
		effective_impulse = 0.0
	elif walljumps > walljump_min_limit:
		effective_impulse = lerpf(walljump_impulse, 0.0, float(walljumps - walljump_min_limit) / float(walljump_max_limit - walljump_min_limit))
	else:
		effective_impulse = walljump_impulse

	velocity.y = effective_impulse
	velocity += direction * walljump_forward_impulse
	velocity += wallrun_normal * walljump_normal_impulse


func start_wallrun() -> void:
	wallrun_normal = Vector3(get_wall_normal().x, 0.0, get_wall_normal().z).normalized()
	wallrun_direction = (get_horizontal_velocity() - wallrun_normal * get_horizontal_velocity().dot(wallrun_normal)).normalized()

	var new_velocity: Vector3 = wallrun_direction * get_horizontal_speed_before_move()
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z


func stop_wallrun() -> void:
	velocity += wallrun_normal * wallrun_cancel_impulse


func add_wallrun_movement() -> void:
	var direction: Vector3 = wallrun_direction * wish_direction.dot(wallrun_direction)

	var old_horizontal_speed: float = get_horizontal_speed()
	velocity += direction * wallrun_acceleration * get_physics_process_delta_time()
	var new_horizontal_speed: float = get_horizontal_speed()

	if new_horizontal_speed <= old_horizontal_speed:
		return

	if new_horizontal_speed <= wallrun_speed:
		return

	var limited_velocity: Vector3

	if old_horizontal_speed <= wallrun_speed:
		limited_velocity = get_horizontal_velocity().limit_length(wallrun_speed)
	else:
		limited_velocity = get_horizontal_velocity().limit_length(old_horizontal_speed)

	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.z


func can_continue_jumping() -> bool:
	return jump_enabled \
	and velocity.y > 0.0 \
	and Global.time - jump_timestamp <= jump_duration


func can_crouch_jump() -> bool:
	return crouch_jump_enabled \
	and (crouch_jump_window == 0.0 or Global.time - crouch_timestamp <= crouch_jump_window)


func can_air_jump() -> bool:
	return air_jump_enabled \
	and air_jumps < air_jump_limit


func can_slide() -> bool:
	return slide_enabled \
	and Global.time - slide_timestamp >= slide_cooldown \
	and not wish_direction.is_zero_approx() \
	and is_zero_approx(get_amount_moving_backwards()) \
	and get_speed() >= slide_start_speed


func can_slide_cancel() -> bool:
	return slide_cancel_enabled \
	and Global.time - slide_timestamp >= slide_cancel_delay


func can_slide_jump() -> bool:
	return slide_jump_enabled \
	and Global.time - slide_timestamp >= slide_jump_delay


func can_continue_sliding() -> bool:
	return slide_enabled \
	and velocity.length() > slide_stop_speed


func can_ledge_jump() -> bool:
	return ledge_jump_enabled \
	and ledge_jump_ready \
	and slide_timestamp == airborne_timestamp \
	and Global.time - airborne_timestamp <= ledge_jump_window


func can_start_wallrun() -> bool:
	if not wallrun_enabled:
		return false

	if Global.time - wallrun_timestamp < wallrun_cooldown:
		return false

	if not is_on_wall():
		return false

	if get_wall_normal().y < -safe_margin:
		return false

	if get_forward_direction().dot(get_direction_of_horizontal_velocity_before_move()) <= 0.0:
		return false

	var normal: Vector3 = Vector3(get_wall_normal().x, 0.0, get_wall_normal().z).normalized()

	if get_direction_of_horizontal_velocity_before_move().angle_to(-normal) < wallrun_min_start_angle:
		return false

	if get_horizontal_speed_before_move() < wallrun_start_speed:
		return false

	wallrun_floor_raycast.force_raycast_update()

	if wallrun_floor_raycast.is_colliding():
		return false

	wallrun_foot_raycast.target_position = basis.inverse() * -normal * collision_shape.shape.radius * 3
	wallrun_hand_raycast.target_position = basis.inverse() * -normal * collision_shape.shape.radius * 3
	wallrun_foot_raycast.force_raycast_update()
	wallrun_hand_raycast.force_raycast_update()

	if not (wallrun_foot_raycast.is_colliding() and wallrun_hand_raycast.is_colliding()):
		return false

	return true


func can_mantle() -> bool:
	if not mantle_enabled:
		return false

	if not is_on_wall():
		return false

	var normal: Vector3 = Vector3(get_wall_normal().x, 0.0, get_wall_normal().z).normalized()

	if get_forward_direction().dot(normal) > 0.0:
		return false

	if wish_direction.is_zero_approx():
		return false

	if wish_direction.angle_to(-normal) > mantle_max_wish_angle:
		return false

	mantle_foot_raycast.target_position = basis.inverse() * -normal * collision_shape.shape.radius * 3
	mantle_foot_raycast.force_raycast_update()

	if not mantle_foot_raycast.is_colliding():
		return false

	mantle_ledge_raycast.position = Vector3(0.0, 2.5, 0.0) + basis.inverse() * -normal * 0.65
	mantle_ledge_raycast.force_raycast_update()

	var floor_normal: Vector3 = mantle_ledge_raycast.get_collision_normal()

	if floor_normal.angle_to(Vector3.UP) > floor_max_angle:
		return false

	mantle_hand_raycast.target_position = basis.inverse() * -normal * collision_shape.shape.radius * 3
	mantle_hand_raycast.force_raycast_update()

	if mantle_hand_raycast.is_colliding():
		return false

	mantle_head_raycast.force_raycast_update()

	if mantle_head_raycast.is_colliding():
		return false

	return true


func can_grapplehook() -> bool:
	return active_grapplehook_point != null \
	and is_grapplehook_point_in_range


func in_coyote_time() -> bool:
	return Time.get_ticks_msec() - coyote_engine_timestamp <= coyote_duration


func can_coyote_jump() -> bool:
	return jump_enabled \
	and coyote_jump_enabled \
	and coyote_jump_ready \
	and in_coyote_time()


func can_coyote_slide() -> bool:
	return slide_enabled \
	and coyote_slide_enabled \
	and coyote_slide_ready \
	and in_coyote_time() \
	and Global.time - slide_timestamp >= slide_cooldown \
	and not wish_direction.is_zero_approx() \
	and is_zero_approx(get_amount_moving_backwards()) \
	and get_speed() >= slide_start_speed


func can_coyote_slide_jump() -> bool:
	return not ledge_jump_enabled \
	and coyote_slide_jump_enabled \
	and coyote_slide_jump_ready \
	and in_coyote_time()


func can_coyote_walljump() -> bool:
	return walljump_enabled \
	and coyote_walljump_enabled \
	and coyote_walljump_ready \
	and in_coyote_time()


func try_stick_to_wallrun() -> bool:
	if get_horizontal_speed() < wallrun_stop_speed:
		return false

	if get_horizontal_velocity().dot(wallrun_direction) <= 0.0:
		return false

	wallrun_floor_raycast.force_raycast_update()

	if wallrun_floor_raycast.is_colliding():
		return false

	var wall_normal: Vector3

	if not is_on_wall():
		wallrun_foot_raycast.target_position = basis.inverse() * -wallrun_normal * collision_shape.shape.radius * 3
		wallrun_hand_raycast.target_position = basis.inverse() * -wallrun_normal * collision_shape.shape.radius * 3
		wallrun_foot_raycast.force_raycast_update()
		wallrun_hand_raycast.force_raycast_update()

		if not (wallrun_foot_raycast.is_colliding() and wallrun_hand_raycast.is_colliding()):
			return false

		wall_normal = Vector3(wallrun_foot_raycast.get_collision_normal().x, 0.0, wallrun_foot_raycast.get_collision_normal().z).normalized()

		if wall_normal.angle_to(wallrun_normal) > wallrun_max_external_angle:
			return false

		move_and_collide(-wallrun_normal * floor_snap_length)

		check_surface(-wallrun_normal)
	else:
		wall_normal = Vector3(get_wall_normal().x, 0.0, get_wall_normal().z).normalized()

		if wall_normal.angle_to(wallrun_normal) > wallrun_max_internal_angle:
			return false

	if wall_normal != wallrun_normal:
		wallrun_normal = Vector3(wall_normal.x, 0.0, wall_normal.z).normalized()
		wallrun_direction = (get_horizontal_velocity() - wallrun_normal * get_horizontal_velocity().dot(wallrun_normal)).normalized()

		velocity.x = wallrun_direction.x * get_horizontal_speed_before_move()
		velocity.y = velocity_before_move.y
		velocity.z = wallrun_direction.z * get_horizontal_speed_before_move()

	return true


func update_active_grapplehook_point() -> void:
	if not grapplehook_enabled:
		clear_grapplehook_point()
		return

	var target_grapplehook_point: GrappleHookPoint = get_targeted_grapplehook_point()

	if target_grapplehook_point == null:
		clear_grapplehook_point()
		return
	elif active_grapplehook_point != target_grapplehook_point:
		clear_grapplehook_point()
		active_grapplehook_point = target_grapplehook_point

	is_grapplehook_point_in_range = active_grapplehook_point.position.distance_to(head.global_position) <= grapplehook_max_distance

	if not is_grapplehook_point_in_range:
		active_grapplehook_point.targeted = GrappleHookPoint.Target.INVALID_TARGET
	elif active_grapplehook_point.targeted != GrappleHookPoint.Target.TARGETED:
		active_grapplehook_point.targeted = GrappleHookPoint.Target.TARGETED
		grapplehook_indicator_audio.play()


func get_targeted_grapplehook_point() -> GrappleHookPoint:
	var grapplehook_points: Array[GrappleHookPoint] = []

	grapplehook_raycast.force_raycast_update()

	while grapplehook_raycast.is_colliding():
		var collider: Node3D = grapplehook_raycast.get_collider()

		if collider is GrappleHookPoint and head.global_position.distance_to(collider.position) >= grapplehook_min_distance:
			grapplehook_points.push_back(collider)
		elif not collider is Area3D:  # If it's not an Area3D in the collision layers the raycast is colliding with, then it must be a StaticBody3D; a wall.
			break

		grapplehook_raycast.add_exception(collider)
		grapplehook_raycast.force_raycast_update()

	grapplehook_raycast.clear_exceptions()

	if grapplehook_points.is_empty():
		return null

	grapplehook_points.sort_custom(_compare_grapplehook_points)

	for grapplehook_point: GrappleHookPoint in grapplehook_points:
		if head.global_position.distance_to(grapplehook_point.position) <= grapplehook_max_distance:
			return grapplehook_point

	return grapplehook_points[0]


func clear_grapplehook_point() -> void:
	if active_grapplehook_point != null:
		active_grapplehook_point.targeted = GrappleHookPoint.Target.NOT_TARGETED
		active_grapplehook_point = null


func _compare_grapplehook_points(a: GrappleHookPoint, b: GrappleHookPoint) -> bool:
	var proximity_to_crosshair_a: float = head.global_position.direction_to(a.position).dot(get_looking_direction())
	var proximity_to_crosshair_b: float = head.global_position.direction_to(b.position).dot(get_looking_direction())
	return proximity_to_crosshair_a > proximity_to_crosshair_b


func _on_health_component_died(_damage_taken: float) -> void:
	state_machine.change_state_to(&"Spawning")
	health_component.revive()
