class_name Player extends CharacterBody3D


@export_group("Spawn")

@export var spawn_position: Node3D

@export_group("Physics")

## The acceleration applied opposite of the player's velocity while they're not moving.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var friction: float = 40
## The acceleration (m/s/s) always applied opposite and proportional to the player's velocity.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var air_resistence: float = 0.15
## The downwards acceleration (m/s/s).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var gravity: float = 30

@export_group("Movement")

## The highest speed (m/s) the player can reach on their own.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var top_speed: float = 4
## How quickly the player accelerates (m/s/s).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var acceleration: float = 80
## What [member top_speed] is multiplied by while moving backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var backwards_speed_multiplier: float = 0.5

@export_group("Air Control")

## What [member top_speed] is multiplied by while airborne.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var airborne_speed_multiplier: float = 0.35
## What [member acceleration] is multiplied by while airborne.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var airborne_acceleration_multiplier: float = 0.35

@export_group("Jumping")

## The speed (m/s) applied upwards when jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var jump_power: float = 8
## The speed (m/s) applied in the movement direction when jumping.
@export_range(0, 10, 0.05, "or_greater", "suffix:m/s") var horizontal_jump_power: float = 1.5
## The time (in seconds) a jump lasts.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var jump_duration: float = 1
## What [member jump_power] is multiplied by when jumping while not moving.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var standing_jump_multiplier: float = 1.1
## What [member gravity] is multiplied by while jumping.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jumping_gravity_multiplier: float = 0.75
## What [member horizontal_jump_power] is multiplied by when jumping backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var backwards_jump_multiplier: float = 0.1
## The amount of times the player can jump while in the air.
@export_range(0, 100, 1, "or_greater") var air_jumps_limit: int = 0

@export_group("Sprinting")

## What [member top_speed] is multiplied by while sprinting.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var sprint_speed_multiplier: float = 1.7
## What [member acceleration] is multiplied by while sprinting.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var sprint_acceleration_multiplier: float = 1.25
## What [member jump_power] is multiplied by while sprinting.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var sprint_jump_multiplier: float = 1.2
## What [member horizontal_jump_power] is multiplied by while sprinting.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var sprint_horizontal_jump_multiplier: float = 1.2

@export_group("Crouching")

## What [member top_speed] is multiplied by while crouching.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var crouch_speed_multiplier: float = 0.5
## What [member acceleration] is multiplied by while crouching.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var crouch_acceleration_multiplier: float = 0.5
## The time (in seconds) it takes to be fully crouched.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var crouch_transition_time: float = 0.1
## What the player's collision height is multiplied by while crouching.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var crouch_height_multiplier: float = 0.5

@export_group("Sliding")

## The speed (m/s) applied in the direction the player is moving when sliding.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_power: float = 6
## The time (in seconds) a slide lasts.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var slide_duration: float = 0.8
## What [member friction] is multiplied by while sliding.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var slide_friction_multiplier: float = 0.1
## The speed (m/s) the player must have while sprinting to slide instead of crouch.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_speed_threshold: float = 0.2
## The speed (m/s) applied upwards when slide jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_jump_power: float = 12
## The speed (m/s) applied in the slide direction when slide jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var slide_horizontal_jump_power: float = -3
## What [member acceleration] is multiplied by while sliding.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var slide_acceleration_multiplier: float = 0.2
## The time (in seconds) that must pass between slides.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var slide_cooldown_duration: float = 0.5

@export_group("Wall-Running")

## The highest speed (m/s) the player can reach while wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_top_speed: float = 8
## How quickly the player accelerates (m/s/s) while wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_acceleration: float = 80
## The speed (m/s) applied perpendicular to the wall when wall-jumping.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_kick_power: float = 4
## The time (in seconds) a wallrun lasts.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var wallrun_duration: float = 2
## What the speed going into a wall gets multiplied by when wall-running.
@export_range(0, 1, 0.05, "suffix:×") var wallrun_speed_conversion_multiplier: float = 0.95
## The acceleration applied opposite of the player's vertical velocity while wall-running (before duration runs out).
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s/s") var wallrun_vertical_friction: float = 15
## What [member air_resistence] is multiplied by while wall-running.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_air_resistence_multiplier: float = 0.85
## What [member friction] is multiplied by while wall-running.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_friction_multiplier: float = 0.25
## What [member gravity] is multiplied by while wall-running (gravity is applied after duration runs out).
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_gravity_multiplier: float = 0.5
## The speed (m/s) the player must have while sprinting to start wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_start_speed_threshold: float = 3
## The speed (m/s) the player must maintain to keep wall-running.
@export_range(0, 100, 0.05, "or_greater", "suffix:m/s") var wallrun_stop_speed_threshold: float = 2
## What the minimum angle (in radians) from the velocity direction to the wall normal needs to be to start wall-running.
@export_range(0, 180, 1, "radians_as_degrees") var wallrun_minimum_angle_threshold: float = deg_to_rad(2)
## What the maximum angle (in radians) from the velocity direction to the wall normal needs to be to start wall-running.
@export_range(0, 180, 1, "radians_as_degrees") var wallrun_maximum_angle_threshold: float = deg_to_rad(88)

@export_group("Buffers")

## The time (in seconds) after leaving the ground the player can still jump during.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var jump_coyote_time: float = 0.1
## The time (in seconds) an action will be buffered for.
@export_range(0, 1, 0.05, "or_greater", "suffix:s") var action_buffer_duration: float = 0.05


@onready var head: Node3D = $Head
@onready var standing_head_y: float = $Head.position.y
@onready var mesh: Node3D = $MeshInstance
@onready var standing_mesh_y: float = $MeshInstance.position.y

@onready var standing_collider_height: float = $CollisionShape.shape.height
@onready var standing_collider_y: float = $CollisionShape.position.y


var input_axis: Vector2 = Vector2.ZERO
var move_direction: Vector3 = Vector3.ZERO
var sprint_action: bool = true

var jump_action_timer: float = 999
var crouch_action_timer: float = 999
var airborne_timer: float = 999
var jump_timer: float = 999
var crouch_timer: float = 0
var slide_timer: float = 999
var slide_end_timer: float = 999
var wallrun_timer: float = 999

var air_jumps: int = 0
var coyote_possible: bool = false

var colliding_velocity: Vector3 = Vector3.ZERO

var wallrun_wall_normal: Vector3 = Vector3.ZERO

var horizontal_colliding_direction: Vector3:
	get:
		return Vector3(colliding_velocity.x, 0, colliding_velocity.z).normalized()

var horizontal_colliding_speed: float:
	get:
		return Vector3(colliding_velocity.x, 0, colliding_velocity.z).length()

var colliding_speed: float:
	get:
		return colliding_velocity.length()

var velocity_direction: Vector3:
	get:
		return velocity.normalized()

var horizontal_velocity_direction: Vector3:
	get:
		return Vector3(velocity.x, 0, velocity.z).normalized()

var speed: float:
	get:
		return velocity.length()

var horizontal_speed: float:
	get:
		return Vector2(velocity.x, velocity.z).length()

var forwards_dot_product: float:
	get:
		return maxf(move_direction.dot(-transform.basis.z), 0)

var backwards_dot_product: float:
	get:
		return maxf(move_direction.dot(transform.basis.z), 0)


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
		sprint_action = not sprint_action
	
	if Input.is_action_just_pressed("crouch"):
		crouch_action_timer = 0


func _process(_delta: float) -> void:
	mesh.scale.y = lerpf(1.0, crouch_height_multiplier, clampf(crouch_timer / crouch_transition_time, 0, 1))
	mesh.position.y = lerpf(standing_mesh_y, standing_mesh_y * crouch_height_multiplier, clampf(crouch_timer / crouch_transition_time, 0, 1))
	head.position.y = lerpf(standing_head_y, standing_head_y * crouch_height_multiplier, clampf(crouch_timer / crouch_transition_time, 0, 1))


func _physics_process(delta: float) -> void:
	move_direction = (transform.basis * Vector3(input_axis.x, 0, input_axis.y)).normalized()
	jump_action_timer += delta
	crouch_action_timer += delta


func consume_jump_action_buffer() -> bool:
	var buffered: bool = jump_action_timer <= action_buffer_duration
	jump_action_timer = 999
	return buffered


func consume_crouch_action_buffer() -> bool:
	var buffered: bool = crouch_action_timer <= action_buffer_duration
	crouch_action_timer = 999
	return buffered


func add_gravity(delta: float, gravity: float) -> void:
	velocity.y -= gravity * delta


func add_air_resistence(delta: float, air_resistence: float) -> void:
	velocity = velocity.move_toward(Vector3.ZERO, air_resistence * speed * delta)


func add_friction(delta: float, friction: float, top_speed: float) -> void:
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


func jump(power: float, horizontal_power: float, direction: Vector3, cancel_gravity: bool, redirect_velocity: bool) -> void:
	if cancel_gravity:
		velocity.y = 0
	
	if direction.is_zero_approx():
		velocity.y += power * standing_jump_multiplier
		return
	
	if redirect_velocity:
		velocity = direction * speed
	
	velocity.y += power
	
	velocity += direction * horizontal_power


func add_force(power: float, direction: Vector3) -> void:
	velocity += direction * power
