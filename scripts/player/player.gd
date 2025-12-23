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

## The acceleration applied towards the ground.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var physics_gravity: float = 30.0


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

## How fast the player slides.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_start_impulse: float = 3.0

## How long the player can slide for.
@export_range(0.0, 1.0, 0.005, "suffix:s") var slide_duration: float = 0.75

## How quickly the player accelerates (to change direction of velocity) while sliding.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var slide_acceleration: float = 16.0

## How much friction is reduced while sliding.
@export_range(0.0, 1.0, 0.05, "suffix:×") var slide_friction_multiplier: float = 0.1

## How fast the player must be moving to slide.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_start_speed: float = 6.5

## How fast the player must be to stay sliding.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var slide_stop_speed: float = 5.0

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
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var ledge_jump_horizontal_impulse: float = 1.0

## How long after sliding off a ledge can the player ledge jump.
@export_range(0.0, 1.0, 0.005, "suffix:s") var ledge_jump_window: float = 0.125


@export_group("Wall-Running", "wall_run")

## Can the player wall-run?
@export var wall_run_enabled: bool = true

## The fast the player can move while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_run_speed: float = 8.0

## How quickly the player accelerates while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wall_run_acceleration: float = 80.0

## How long the player can wall-run until they start sliding.
@export_range(0.0, 1.0, 0.005, "suffix:s") var wall_run_duration: float = 0.1

## How fast the player must be to start wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_run_start_speed: float = 5.5

## How fast the player must be until they stop wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_run_stop_speed: float = 2.0

## How much air resistence is applied while wall-running.
@export_range(0.0, 1.0, 0.05, "suffix:×") var wall_run_air_resistence_multiplier: float = 0.5

## How much gravity is applied while sliding on a wall.
@export_range(0.0, 1.0, 0.05, "suffix:×") var wall_run_gravity_multiplier: float = 0.5

## How much friction is applied horizontally while sliding on a wall.
@export_range(0.0, 1.0, 0.05, "suffix:×") var wall_run_friction_multiplier: float = 0.3

## The acceleration opposing upwards movement while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wall_run_upwards_friction: float = 20.0

## The acceleration opposing downwards movement while wall-running.
@export_range(0.0, 500.0, 1.0, "suffix:m/s/s") var wall_run_downwards_friction: float = 45.0

## How hard the player is pushed from a wall when they cancel a wall-run.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_run_cancel_impulse: float = 2.0

## How long the player must wait after a wallrun until they can wallrun again.
@export_range(0.0, 1.0, 0.005, "suffix:s") var wall_run_cooldown: float = 0.25

## The largest external angle a wall can have for the player to stay running on it.
@export_range(0.0, 89.0, 1.0, "radians_as_degrees") var wall_run_max_external_angle: float = deg_to_rad(15.0)

## The largest internal angle a wall can have for the player to stay running on it.
@export_range(0.0, 89.0, 1.0, "radians_as_degrees") var wall_run_max_internal_angle: float = deg_to_rad(45.0)


@export_subgroup("Wall-Jumping", "wall_jump_")

## How many times the player can wall-jump with full power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_jump_min_limit: int = 4

## How many wall-jumps until the player has no wall-jump power.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_jump_max_limit: int = 8

## How high the player jumps while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_jump_impulse: float = 9.0

## How far the player jumps forwards while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_jump_forward_impulse: float = -4.5

## How far the player jumps away from the wall while wall-running.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var wall_jump_normal_impulse: float = 9.0


@export_group("Mantling", "mantle_")

## Can the player mantle?
@export var mantle_enabled: bool = true

## How quickly the player mantles over a ledge.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var mantle_speed: float = 18.0

## How high the player is sent upwards when mantling.
@export_range(0, 100, 0.05, "suffix:m/s") var mantle_power: float = 2.0

## How much of the player's speed is lost when they mantle.
@export_range(0.0, 1.0, 0.05, "suffix:×") var mantle_speed_penalty: float = 0.1



@export_group("Grapple Hooking", "grapple_hook_")

## Can the player grapple hook?
@export var grapple_hook_enabled: bool = true

## How fast the player is pulled towards the grapple point when grapple hooking.
@export_range(0.0, 100.0, 0.05, "suffix:m/s") var grapple_hook_speed: float = 6.0

## How far from the grapple point the player must be to grapple to it.
@export_range(0.0, 50.0, 0.05, "suffix:m") var grapple_hook_min_distance: float = 7.0

## How close to the grapple point the player must be to grapple to it.
@export_range(0.0, 50.0, 0.05, "suffix:m") var grapple_hook_max_distance: float = 14.0


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
var wall_run_timestamp: float = 0.0

var air_crouching: bool = false
var coyote_jump_ready: bool = false
var coyote_slide_ready: bool = false
var coyote_slide_jump_ready: bool = false
var coyote_wall_jump_ready: bool = false
var ledge_jump_ready: bool = false
var grapple_hook_point_in_range: bool = false

var air_jumps: int = Global.MAX_INT
var air_crouches: int = Global.MAX_INT
var wall_jumps: int = 0

var wall_run_normal: Vector3 = Vector3.ZERO
var wall_run_direction: Vector3 = Vector3.ZERO
var mantle_velocity: Vector3 = Vector3.ZERO

var active_grapple_hook_point: GrappleHookPoint = null


##################################################
# Child References
##################################################


@onready var head: Node3D = $Head
@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var health_component: HealthComponent = $HealthComponent
@onready var grapple_hook_raycast: RayCast3D = $Head/Camera/GrappleHookRaycast
@onready var grapple_hook_line: Line3D = $Head/Camera/GrappleHookRaycast/GrappleHookLine
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
@onready var grapple_hook_fire_audio: AudioStreamPlayer3D = $GrappleHookFireAudio
@onready var grapple_hook_indicator_audio: AudioStreamPlayer = $GrappleHookIndicatorAudio


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


## Returns the speed of the player.
func get_speed() -> float:
	return velocity.length()


## Returns the normalized velocity of the player.
func get_direction_of_velocity() -> Vector3:
	return velocity.normalized()


## Returns the vertical velocity of the player.
func get_vertical_velocity() -> Vector3:
	return up_direction * velocity.dot(up_direction)


## Returns the vertical speed of the player.
func get_vertical_speed() -> float:
	return absf(velocity.dot(up_direction))


## Returns the normalized vertical velocity of the player.
func get_direction_of_vertical_velocity() -> float:
	return signf(velocity.dot(up_direction))


## Returns the horizontal velocity of the player.
func get_horizontal_velocity() -> Vector3:
	return velocity - get_vertical_velocity()


## Returns the horizontal speed of the player.
func get_horizontal_speed() -> float:
	return get_horizontal_velocity().length()


## Returns the normalized horizontal velocity of the player.
func get_direction_of_horizontal_velocity() -> Vector3:
	return get_horizontal_velocity().normalized()


## Returns the player's center of mass.
func get_center_of_mass() -> Vector3:
	return collision_shape.global_position


##################################################
# Player Functions
##################################################


func move() -> void:
	floor_block_on_wall = is_on_floor()

	move_and_slide()

	if not is_on_floor():
		velocity = get_real_velocity()


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


func make_vertical_velocity_zero() -> void:
	velocity = get_horizontal_velocity()


func add_air_resistence(air_resistence: float) -> void:
	var current_speed: float = get_speed()

	velocity = velocity.move_toward(Vector3.ZERO, air_resistence * current_speed * get_physics_process_delta_time())


func add_friction(friction: float, top_speed: float) -> void:
	var friction_direction: Vector3 = -get_direction_of_velocity()

	# When friction direction and movement direction oppose each other, dot product = -1, +1 = 0
	# Clamp between 0 and 1 to not apply more friction when friction direction aligns with movement direction
	var friction_product: float = minf(friction_direction.dot(wish_direction) + 1.0, 1.0)

	# If player is faster than the top speed they can move at, it will always apply friction. A reduced amount if going against the movement direction
	var current_speed: float = velocity.length()

	if current_speed > top_speed:
		var scaled_friction_product: float = lerpf(move_friction_multiplier, 1, friction_product)

		velocity = velocity.move_toward(velocity.limit_length(top_speed), friction * get_physics_process_delta_time() * scaled_friction_product)
		return

	# Otherwise, it only applies friction if it doesn't go against the movement direction

	velocity = velocity.move_toward(Vector3.ZERO, friction * friction_product * get_physics_process_delta_time())


func add_gravity(gravity: float) -> void:
	velocity += -up_direction * gravity * get_physics_process_delta_time()


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

	var old_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	velocity += wish_direction * acceleration * backwards_multiplier * get_physics_process_delta_time()
	var new_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()

	if new_horizontal_speed <= old_horizontal_speed:
		return

	if new_horizontal_speed <= top_speed * backwards_multiplier:
		return

	var limited_velocity: Vector3

	if old_horizontal_speed <= top_speed * backwards_multiplier:
		limited_velocity = Vector3(velocity.x, 0.0, velocity.z).limit_length(top_speed * backwards_multiplier)
	else:
		limited_velocity = Vector3(velocity.x, 0.0, velocity.z).limit_length(old_horizontal_speed)

	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.z


func jump() -> void:
	attempt_uncrouch()

	var effective_impulse: float = lerpf(jump_standing_impulse, jump_impulse, wish_direction.length())
	var effective_horizontal_impulse: float = jump_horizontal_impulse

	if proportional_jump_enabled:
		var horizontal_speed: float = get_horizontal_velocity().length()
		var proportional_jump_weight: float = clampf((horizontal_speed - proportional_jump_base_speed) / (proportional_jump_top_speed - proportional_jump_base_speed), 0.0, 1.0)

		effective_impulse = lerpf(effective_impulse, proportional_jump_top_impulse, proportional_jump_weight)
		effective_horizontal_impulse = lerpf(effective_horizontal_impulse, proportional_jump_top_horizontal_impulse, proportional_jump_weight)

	velocity += up_direction * effective_impulse
	velocity += wish_direction * effective_horizontal_impulse


func ledge_jump() -> void:
	attempt_uncrouch()

	velocity += up_direction * ledge_jump_impulse
	velocity += wish_direction * ledge_jump_horizontal_impulse


func air_jump() -> void:
	attempt_uncrouch()

	velocity = Vector3.ZERO

	var effective_impulse: float = lerpf(air_jump_standing_impulse, air_jump_impulse, wish_direction.length())

	velocity += up_direction * effective_impulse
	velocity += wish_direction * air_jump_horizontal_impulse


func slide() -> void:
	stance = Stances.SPRINTING
	crouch()

	make_vertical_velocity_zero()
	velocity += wish_direction * slide_start_impulse


func slide_jump() -> void:
	attempt_uncrouch()

	velocity += up_direction * slide_jump_impulse
	velocity += velocity.normalized() * slide_jump_horizontal_impulse


func add_wallrun_movement(run_direction: Vector3) -> void:
	var direction: Vector3 = run_direction * wish_direction.dot(run_direction)

	var old_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	velocity += direction * wall_run_acceleration * get_physics_process_delta_time()
	var new_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()

	if new_horizontal_speed <= old_horizontal_speed:
		return

	if new_horizontal_speed <= wall_run_speed:
		return

	var limited_velocity: Vector2

	if old_horizontal_speed <= wall_run_speed:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(wall_run_speed)
	else:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(old_horizontal_speed)

	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.y


func wall_jump(wall_normal: Vector3, run_direction: Vector3) -> void:
	wall_jumps += 1

	var effective_impulse: float

	if wall_jumps == wall_jump_max_limit:
		effective_impulse = 0.0
	elif wall_jumps > wall_jump_min_limit:
		effective_impulse = lerpf(wall_jump_impulse, 0.0, float(wall_jumps - wall_jump_min_limit) / float(wall_jump_max_limit - wall_jump_min_limit))
	else:
		effective_impulse = wall_jump_impulse

	velocity += -(up_direction * velocity.dot(up_direction)) + up_direction * effective_impulse
	velocity += run_direction * wall_jump_forward_impulse
	velocity += wall_normal * wall_jump_normal_impulse


func get_targeted_grapple_hook_point() -> GrappleHookPoint:
	var grapple_hook_points: Array[GrappleHookPoint] = []

	grapple_hook_raycast.force_raycast_update()

	while grapple_hook_raycast.is_colliding():
		var collider: Node3D = grapple_hook_raycast.get_collider()

		if collider is GrappleHookPoint and head.global_position.distance_to(collider.position) >= grapple_hook_min_distance:
			grapple_hook_points.push_back(collider)
		elif not collider is Area3D:  # If it's not an Area3D in the collision layers the raycast is colliding with, then it must be a StaticBody3D; a wall.
			break

		grapple_hook_raycast.add_exception(collider)
		grapple_hook_raycast.force_raycast_update()

	grapple_hook_raycast.clear_exceptions()

	if grapple_hook_points.is_empty():
		return null

	grapple_hook_points.sort_custom(_compare_grapple_hook_points)

	for grapple_hook_point: GrappleHookPoint in grapple_hook_points:
		if head.global_position.distance_to(grapple_hook_point.position) <= grapple_hook_max_distance:
			return grapple_hook_point

	return grapple_hook_points[0]


func _compare_grapple_hook_points(a: GrappleHookPoint, b: GrappleHookPoint) -> bool:
	var proximity_to_crosshair_a: float = head.global_position.direction_to(a.position).dot(get_looking_direction())
	var proximity_to_crosshair_b: float = head.global_position.direction_to(b.position).dot(get_looking_direction())
	return proximity_to_crosshair_a > proximity_to_crosshair_b


func _on_health_component_died(_damage_taken: float) -> void:
	state_machine.change_state_to(&"Spawning")
	health_component.revive()
