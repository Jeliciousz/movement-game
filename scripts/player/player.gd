class_name Player extends CharacterBody3D


@export_group("Physics")

## The acceleration applied opposite of the player's velocity while not moving.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var physics_friction: float = 40
## The acceleration (m/s/s) applied opposite and proportional to the player's velocity.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var physics_air_resistence: float = 0.15
## The acceleration (m/s/s) applied downwards.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var physics_gravity: float = 30

@export_group("Movement", "move_")

## The fastest speed (m/s) the player can reach.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var move_speed: float = 4
## How quickly the player accelerates (m/s/s).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var move_acceleration: float = 80
## What [member move_speed] is multiplied by while moving backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var move_backwards_multiplier: float = 0.5
## What [member physics_friction] is multiplied by while moving faster than top speed (only applied when friction goes against movement direction).
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var move_top_speed_friction_multiplier: float = 0.5

@export_subgroup("Air Control", "air_")

## The fastest speed (m/s) the player can reach while airborne.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var air_speed: float = 1.5
## How quickly the player accelerates (m/s/s) while airborne.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var air_acceleration: float = 25

@export_subgroup("Sprinting", "sprint_")

## The highest speed (m/s) the player can reach while sprinting.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var sprint_speed: float = 7
## How quickly the player accelerates (m/s/s) while sprinting.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var sprint_acceleration: float = 100

@export_group("Crouching", "crouch_")

## The highest speed (m/s) the player can reach while crouching.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var crouch_speed: float = 2
## How quickly the player accelerates (m/s/s) while crouching.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var crouch_acceleration: float = 40
## What the player's collision height is multiplied by while crouching.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var crouch_height_multiplier: float = 0.5

@export_group("Jumping", "jump_")

## The speed (m/s) applied upwards when jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var jump_power: float = 8
## The speed (m/s) applied in the movement direction when jumping.
@export_range(0, 10, 0.05, "or_greater", "suffix:m/s") var jump_horizontal_power: float = 1.5
## The time (milliseconds) a jump lasts.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var jump_duration: int = 0
## The time (milliseconds) after leaving the ground that the player can coyote jump during.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var jump_coyote_duration: int = 125
## What [member jump_power] is multiplied by when jumping while not moving.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_standing_multiplier: float = 1.1
## What [member jump_horizontal_power] is multiplied by when jumping backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_backwards_multiplier: float = 0.1
## What [member physics_gravity] is multiplied by while jumping.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_gravity_multiplier: float = 0.75

@export_subgroup("Speed Jumping", "jump_")

## The speed (m/s) needed to achieve base jump power.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var jump_min_speed: float = 4
## The speed (m/s) needed to achieve max jump power.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var jump_max_speed: float = 8
## The speed (m/s) applied upwards when jumping at max speed.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var jump_max_power: float = 10
## The speed (m/s) applied in the movement direction when jumping at max speed.
@export_range(0, 10, 0.05, "or_greater", "suffix:m/s") var jump_max_horizontal_power: float = 0.85

@export_subgroup("Air Jumping", "air_jump_")

## The speed (m/s) applied in the movement direction when air jumping.
@export_range(0, 10, 0.05, "or_greater", "suffix:m/s") var air_jump_horizontal_power: float = 9
## The amount of times the player can jump in the air before touching the ground.
@export_range(0, 100, 1, "or_greater") var air_jump_limit: int = 0

@export_group("Sliding", "slide_")

## The speed (m/s) applied in the direction the player is moving when sliding.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_power: float = 6
## The time (milliseconds) a slide lasts.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_duration: int = 1000
## The speed (m/s) the player must have while sprinting to slide instead of crouch.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_start_speed_threshold: float = 2
## The speed (m/s) the player will stop sliding at.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_stop_speed_threshold: float = 4
## The acceleration applied opposite of the player's velocity while sliding and not moving.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var slide_friction: float = 4
## How quickly the player accelerates (m/s/s) while sliding.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var slide_acceleration: float = 16
## The time (milliseconds) that must pass between slides.
@export_range(0, 1, 0.05, "or_greater", "suffix:ms") var slide_cooldown_duration: int = 350
## The time (milliseconds) after leaving the ground that the player can coyote slide during.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_coyote_duration: int = 125
## The time (milliseconds) that must pass after sliding before the player can jump.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_jump_cooldown_duration: int = 250
## The time (milliseconds) that must pass after after sliding before the player can cancel the slide.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_cancel_cooldown_duration: int = 500

@export_subgroup("Slide Jumping", "slide_jump_")

## The speed (m/s) applied upwards when slide jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_jump_power: float = 14
## The speed (m/s) applied in the slide direction when slide jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_jump_horizontal_power: float = -4

@export_group("Wall-Running")

## The highest speed (m/s) the player can reach while wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_top_speed: float = 8
## How quickly the player accelerates (m/s/s) while wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_acceleration: float = 80
## The speed (m/s) applied upwards when wall-jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_jump_power: float = 9
## The speed (m/s) applied in the velocity direction when wall-jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_jump_horizontal_power: float = -6
## The speed (m/s) applied perpendicular to the wall when wall-jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_kick_power: float = 12
## The time (milliseconds) a wallrun lasts.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var wallrun_duration: int = 2000
## What the speed going into a wall gets multiplied by when wall-running.
@export_range(0, 1, 0.05, "suffix:×") var wallrun_speed_conversion_multiplier: float = 1
## The acceleration (m/s/s) applied downwards (gravity is applied after duration runs out).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_gravity: float = 15
## The acceleration applied opposite of the player's horizontal velocity while wall-running (before duration runs out).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_friction: float = 6
## The acceleration applied opposite of the player's vertical velocity while wall-running (before duration runs out).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_vertical_friction: float = 25
## The acceleration (m/s/s) applied opposite and proportional to the player's velocity while wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_air_resistence: float = 0.10
## The speed (m/s) the player must have to start wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_start_speed_threshold: float = 5
## The speed (m/s) the player must maintain to keep wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_stop_speed_threshold: float = 3

@export_group("Air-Dashing", "air_dash_")
## The speed (m/s) applied in the direction the player is looking when air-dashing.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var air_dash_power: float = 12
## The speed (m/s) applied upwards when air-dashing.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var air_dash_vertical_power: float = 2
## The time (milliseconds) an air-dash lasts.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var air_dash_duration: int = 350
## The speed (m/s) applied opposite to the player's velocity at the end of an air-dash.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var air_dash_end_power: float = 4
## What [member gravity] is multiplied by while air-dashing.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var air_dash_gravity_multiplier: float = 0.15
## The amount of times the player can air-dash before touching the ground.
@export_range(0, 100, 1, "or_greater") var air_dash_limit: int = 0


var move_direction: Vector3 = Vector3.ZERO

var colliding_velocity: Vector3 = Vector3.ZERO

var is_sprinting: bool = true

var airborne_timestamp: int = 0
var grounded_timestamp: int = 0
var jump_timestamp: int = 0
var crouch_timestamp: int = 0
var slide_timestamp: int = 0
var wallrun_timestamp: int = 0
var air_dash_timestamp: int = 0

var coyote_jump_possible: bool = false
var coyote_slide_possible: bool = false
var air_jumps: int = 0
var air_dashes: int = 0

var wallrun_wall_normal: Vector3 = Vector3.ZERO
var wallrun_run_direction: Vector3 = Vector3.ZERO

## Returns how much the player is moving backwards.[br]
## 0: Player is strafing or moving forwards[br]
## 1: Player is moving directly backwards
func get_amount_moving_backwards() -> float:
	return maxf(0, move_direction.dot(transform.basis.z))


func get_look_direction() -> Vector3:
	return -transform.basis.z


# This is called after the state machine has finished processing for the physics tick

func _physics_process(delta: float) -> void:
	colliding_velocity = velocity
	
	move_and_slide()
	
	if not is_on_floor():
		velocity = get_real_velocity()
		floor_block_on_wall = false
	else:
		floor_block_on_wall = true



func add_velocity(power: float, direction: Vector3) -> void:
	velocity += direction * power


func add_gravity(delta: float, gravity: float) -> void:
	add_velocity(gravity * delta, Vector3.DOWN)


func add_air_resistence(delta: float, air_resistence: float) -> void:
	var current_speed = velocity.length()
	
	set_velocity(velocity.move_toward(Vector3.ZERO, air_resistence * current_speed * delta))


func add_friction(delta: float, friction: float, top_speed: float) -> void:
	# Only apply friction when it doesn't go against the player's movement direction
	
	var velocity_direction = velocity.normalized()
	
	var friction_direction = -velocity_direction
	
	# When friction direction and movement direction oppose each other, dot product = -1, +1 = 0
	# Clamp between 0 and 1 to not apply more friction when friction direction aligns with movement direction
	var friction_product = minf(friction_direction.dot(move_direction) + 1, 1)
	
	# If player is faster than the top speed they can move at, it will always apply friction. a reduced amount if going against the movement direction
	var current_speed = velocity.length()
	
	if current_speed > top_speed:
		var scaled_friction_product = lerpf(move_top_speed_friction_multiplier, 1, friction_product)
		
		set_velocity(velocity.move_toward(velocity.limit_length(top_speed), friction * delta * scaled_friction_product))
		return
	
	# Otherwise, it only applies friction if it doesn't go against the movement direction
	
	velocity = velocity.move_toward(Vector3.ZERO, friction * friction_product * delta)


func add_movement(delta: float, top_speed: float, acceleration: float) -> void:
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
	
	var old_horizontal_speed = Vector2(velocity.x, velocity.z).length()
	add_velocity(acceleration * delta, move_direction)
	var new_horizontal_speed = Vector2(velocity.x, velocity.z).length()
	
	if new_horizontal_speed <= old_horizontal_speed:
		return
	
	if new_horizontal_speed <= top_speed:
		return
	
	var limited_velocity: Vector2
	
	if old_horizontal_speed <= top_speed:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(top_speed)
	else:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(old_horizontal_speed)
	
	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.y


func jump() -> void:
	var backwards_multiplier = lerpf(1, jump_backwards_multiplier, get_amount_moving_backwards())
	var standing_multiplier = lerpf(jump_standing_multiplier, 1, move_direction.length())
	
	# Speed Jumping
	var current_horizontal_speed = Vector2(velocity.x, velocity.z).length()
	var weight: float = clampf((current_horizontal_speed - jump_min_speed) / (jump_max_speed - jump_min_speed), 0, 1)
	
	var power = lerpf(jump_power, jump_max_power, weight) * standing_multiplier
	var horizontal_power = lerpf(jump_horizontal_power, jump_max_horizontal_power, weight) * backwards_multiplier
	
	velocity.y += power
	
	add_velocity(horizontal_power, move_direction)


func air_jump() -> void:
	velocity = Vector3.ZERO
	air_jumps += 1
	
	var backwards_multiplier = lerpf(1, jump_backwards_multiplier, get_amount_moving_backwards())
	var standing_multiplier = lerpf(jump_standing_multiplier, 1, move_direction.length())
	
	var power = jump_power * standing_multiplier
	var horizontal_power = air_jump_horizontal_power * backwards_multiplier
	
	velocity.y = power
	
	add_velocity(horizontal_power, move_direction)


func slide_jump() -> void:
	velocity.y = slide_jump_power
	
	add_velocity(slide_jump_horizontal_power, velocity.normalized())


func wall_jump() -> void:
	velocity.y = 0
	
	velocity.y += wallrun_jump_power
	
	add_velocity(wallrun_jump_horizontal_power, Vector3(velocity.x, 0, velocity.z).normalized())
	
	add_velocity(wallrun_kick_power, wallrun_wall_normal)
