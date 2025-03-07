class_name Player extends CharacterBody3D


@export_group("Physics")

## The acceleration (m/s/s) applied opposite of the player's velocity while they're not moving.
@export var friction: float = 40
## The acceleration (m/s/s) always applied opposite and proportional to the player's velocity.
@export var air_resistence: float = 0.2
## The downwards acceleration (m/s/s).
@export var gravity: float = 30

@export_group("Movement")

## The highest speed (m/s) the player can reach on their own.
@export var top_speed: float = 4
## How quickly the player accelerates (m/s/s).
@export var acceleration: float = 80

@export_group("Air Control")

## What [member top_speed] is multiplied by while airborne.
@export var airborne_speed_multiplier: float = 0.35
## What [member acceleration] is multiplied by while airborne.
@export var airborne_acceleration_multiplier: float = 0.35

@export_group("Jumping")

## The speed (m/s) applied upwards when jumping.
@export var jump_power: float = 8
## The speed (m/s) applied in the movement direction when jumping.
@export var horizontal_jump_power: float = 3
## What [member jump_power] is multiplied by when jumping while not moving.
@export var standing_jump_multiplier: float = 1.1
## The time (in seconds) a jump lasts.
@export var jump_duration: float = 1.5
## What [member gravity] is multiplied by while jumping.
@export var jumping_gravity_multiplier: float = 0.7

@export_group("Sprinting")

## What [member top_speed] is multiplied by while sprinting.
@export var sprint_speed_multiplier: float = 1.7
## What [member acceleration] is multiplied by while sprinting.
@export var sprint_acceleration_multiplier: float = 1.25
## What [member jump_power] is multiplied by while sprinting.
@export var sprint_jump_multiplier: float = 1.2
## What [member horizontal_jump_power] is multiplied by while sprinting.
@export var sprint_horizontal_jump_multiplier: float = 1.2

@export_group("Crouching")

## What [member top_speed] is multiplied by while crouching.
@export var crouch_speed_multiplier: float = 0.5
## What [member acceleration] is multiplied by while crouching.
@export var crouch_acceleration_multiplier: float = 0.5
## The time (in seconds) it takes to be fully crouched.
@export var crouch_transition_time: float = 0.35

@export_group("Buffers")

## The time (in seconds) after leaving the ground the player can still jump during.
@export var jump_coyote_time: float = 0.15
## The time (in seconds) a jump action will be buffered for.
@export var jump_buffer_duration: float = 0.1


var input_axis: Vector2 = Vector2.ZERO
var move_direction: Vector3 = Vector3.ZERO
var sprinting_action: bool = true

var jump_action_timer: float = 999
var airborne_timer: float = 999
var jump_timer: float = 999
var crouch_timer: float = 999


var velocity_direction: Vector3:
	get:
		return velocity.normalized()

var horizontal_velocity_direction: Vector2:
	get:
		return Vector2(velocity.x, velocity.z).normalized()

var speed: float:
	get:
		return velocity.length()

var horizontal_speed: float:
	get:
		return Vector2(velocity.x, velocity.z).length()


func _unhandled_input(_event: InputEvent) -> void:
	#	This handles the movement inputs
	#
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
	#	This is called "Null-Canceling Movement", a concept I borrowed from a TF2 script, but I designed this code myself
	#
	#	The vector is normalized and transformed by the player direction in the process step
	#
	#	-Jeliciousz
	
	if Input.is_action_just_pressed("back"):
		input_axis.y = 1
	elif Input.is_action_just_released("back"):
		input_axis.y = -float(Input.is_action_pressed("forward"))
	
	if Input.is_action_just_pressed("forward"):
		input_axis.y = -1
	elif Input.is_action_just_released("forward"):
		input_axis.y = float(Input.is_action_pressed("back"))
	
	if Input.is_action_just_pressed("left"):
		input_axis.x = -1
	elif Input.is_action_just_released("left"):
		input_axis.x = float(Input.is_action_pressed("right"))
	
	if Input.is_action_just_pressed("right"):
		input_axis.x = 1
	elif Input.is_action_just_released("right"):
		input_axis.x = -float(Input.is_action_pressed("left"))
	
	
	if Input.is_action_just_pressed("jump"):
		jump_action_timer = 0
	
	if Input.is_action_just_pressed("sprint"):
		sprinting_action = not sprinting_action


func _process(delta: float) -> void:
	move_direction = (transform.basis * Vector3(input_axis.x, 0, input_axis.y)).normalized()
	jump_action_timer += delta
	crouch_timer += delta


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if position.y < -10:
		position = Vector3.ZERO


func add_gravity(delta: float, gravity: float = gravity) -> void:
	velocity.y -= gravity * delta


func add_air_resistence(delta: float) -> void:
	velocity = velocity.move_toward(Vector3.ZERO, air_resistence * speed * delta)


func add_friction(delta: float) -> void:
	# If player is faster than the top speed they can move at, it just applies friction ignoring movement direction
	
	if speed > top_speed:
		velocity = velocity.move_toward(velocity.limit_length(top_speed), friction * delta)
		return
	
	# Otherwise, it applies friction only when it doesn't go against the player's movement direction
	
	var friction_direction = -velocity_direction
	
	# When friction direction and movement direction oppose each other, dot product = -1, +1 = 0
	# Clamp between 0 and 1 to not apply more friction when friction direction aligns with movement direction
	var friction_product = minf(friction_direction.dot(move_direction) + 1, 1) 
	
	velocity = velocity.move_toward(Vector3.ZERO, friction * friction_product * delta)


func add_movement(delta: float, top_speed: float = top_speed, acceleration: float = acceleration) -> void:
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
	
	var old_horizontal_speed = horizontal_speed
	velocity += move_direction * acceleration * delta
	var new_horizontal_speed = horizontal_speed
	
	if new_horizontal_speed < old_horizontal_speed:
		return
	
	if new_horizontal_speed <= top_speed:
		return
	
	if old_horizontal_speed <= top_speed:
		var limited_velocity = Vector2(velocity.x, velocity.z).limit_length(top_speed)
		velocity.x = limited_velocity.x
		velocity.z = limited_velocity.y
		
		return
	
	var limited_velocity = Vector2(velocity.x, velocity.z).limit_length(old_horizontal_speed)
	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.y


func jump(cancel_velocity: bool = false, jump_power: float = jump_power, horizontal_jump_power: float = horizontal_jump_power) -> void:
	jump_timer = 0
	
	if cancel_velocity:
		velocity.y = 0
	
	if move_direction.is_zero_approx():
		velocity.y += jump_power * standing_jump_multiplier
		return
	
	velocity.y += jump_power
	
	var move_product = maxf(move_direction.dot(-transform.basis.z), 0)
	velocity += move_direction * horizontal_jump_power * move_product
