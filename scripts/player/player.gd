class_name Player extends CharacterBody3D


@export_group("Physics", "physics_")

## The acceleration applied against the direction of the player's velocity.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var physics_friction: float = 40

## The acceleration applied opposite and proportional to the player's velocity.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var physics_air_resistence: float = 0.125

## The acceleration applied downwards.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var physics_gravity: float = 30


@export_group("Coyote Time", "coyote_")

## Is there coyote time?
@export var coyote_enabled: bool = true

## How long coyote time lasts.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var coyote_duration: int = 125


@export_group("Movement", "move_")

## How fast the player can move.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var move_speed: float = 4

## How quickly the player accelerates.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var move_acceleration: float = 80

## How quickly the player can move backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var move_backwards_multiplier: float = 0.5

## How much friction is applied against the direction the player is moving.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var move_friction_multiplier: float = 0.75


@export_subgroup("Air Control", "air_")

## How fast the player can move in the air.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var air_speed: float = 1.5

## How quickly the player accelerates in the air.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var air_acceleration: float = 40


@export_group("Jumping", "jump_")

## Can the player jump?
@export var jump_enabled: bool = true

## How high the player jumps.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var jump_power: float = 8

## How high the player can jump while standing still.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_standing_multiplier: float = 1.1

## How far the player jumps in the direction they're moving.
@export_range(0, 10, 0.05, "or_less", "or_greater", "suffix:m/s") var jump_horizontal_power: float = 1.5

## How far the player can jump backwards.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_backwards_multiplier: float = 0.1

## How long the player can jump for.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var jump_duration: int = 350

## How much gravity is applied while the player is jumping.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var jump_gravity_multiplier: float = 0.8


@export_subgroup("Speed Jumping", "speed_jump_")

## Can the player speed jump?
@export var speed_jump_enabled: bool = true

## The speed at or below which the player has base jump power.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var speed_jump_base_speed: float = 4

## The speed at or above which the player has max jump power.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var speed_jump_max_speed: float = 8

## How high the player jumps at max speed.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var speed_jump_max_power: float = 10

## How far the player jumps in the direction they're moving at max speed.
@export_range(0, 10, 0.05, "or_less", "or_greater", "suffix:m/s") var speed_jump_max_horizontal_power: float = 1.5


@export_subgroup("Air Jumping", "air_jump_")

## Can the player air jump?
@export var air_jump_enabled: bool = false

## How far the player jumps in the direction they're moving while airborne.
@export_range(0, 10, 0.05, "or_less", "or_greater", "suffix:m/s") var air_jump_horizontal_power: float = 8

## How many times the player can air jump before touching the ground.
@export_range(0, 100, 1, "or_greater") var air_jump_limit: int = 1


@export_group("Sprinting", "sprint_")

## Can the player sprint?
@export var sprint_enabled: bool = true

## How fast the player can move while sprinting.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var sprint_speed: float = 7

## How quickly the player accelerates while sprinting.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var sprint_acceleration: float = 100


@export_group("Crouching", "crouch_")

## Can the player crouch?
@export var crouch_enabled: bool = true

## How tall the player is while crouching.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var crouch_height_multiplier: float = 0.5

## How fast the player can move while crouching.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var crouch_speed: float = 2

## How quickly the player accelerates while crouching.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var crouch_acceleration: float = 40


@export_subgroup("Air Crouching", "air_crouch_")

## Can the player crouch in the air?
@export var air_crouch_enabled: bool = false

## How many times the player can crouch in the air before touching the ground.
@export_range(0, 100, 1, "or_greater") var air_crouch_limit: int = 1


@export_group("Sliding", "slide_")

## Can the player slide?
@export var slide_enabled: bool = true

## How fast the player slides.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_power: float = 6

## How long the player can slide for.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_duration: int = 1000

## How quickly the player accelerates while sliding.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var slide_acceleration: float = 16

## How much friction is applied while sliding.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var slide_friction_multiplier: float = 0.1

## How fast the player must be moving to slide.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_start_speed: float = 5

## How fast the player must be until they stop sliding.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_stop_speed: float = 4

## How long the player must wait after a slide until they can slide again.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_cooldown: int = 350


@export_subgroup("Slide Canceling", "slide_cancel_")

## Can the player slide cancel?
@export var slide_cancel_enabled: bool = true

## How long the player must wait after starting a slide until they can slide cancel.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_cancel_delay: int = 350


@export_subgroup("Slide Jumping", "slide_jump_")

## Can the player slide jump?
@export var slide_jump_enabled: bool = true

## How high the player jumps while sliding.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_jump_power: float = 14

## How far the player jumps in the direction they're moving while sliding.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var slide_jump_horizontal_power: float = -3

## How long the player must wait after starting a slide until they can slide jump.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var slide_jump_delay: int = 250


@export_group("Wall-Running")

## Can the player wall-run?
@export var wallrun_enabled: bool = true

## The fast the player can move while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var wallrun_top_speed: float = 8

## How quickly the player accelerates while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var wallrun_acceleration: float = 80

## How long the player can wall-run for until they start sliding.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var wallrun_duration: int = 2000

## The acceleration applied against the direction of the velocity in the vertical axis while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s/s") var wallrun_vertical_friction: float = 25

## How much air resistence is applied while wall-running.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_air_resistence_multiplier: float = 0.5

## How much gravity is applied while sliding on a wall.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_gravity_multiplier: float = 0.5

## How much friction is applied while sliding on a wall.
@export_range(-1, 2, 0.05, "or_less", "or_greater", "suffix:×") var wallrun_friction_multiplier: float = 0.15

## How fast the player must be to start wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var wallrun_start_speed: float = 3

## How fast the player must be until they stop wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var wallrun_stop_speed: float = 2

## How long the player must wait after a wallrun until they can wallrun again.
@export_range(0, 1000, 1, "or_greater", "suffix:ms") var wallrun_cooldown: int = 200


@export_group("Wall-Jumping", "walljump_")

## Can the player wall-jump?
@export var walljump_enabled: bool = true

## How high the player jumps while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var walljump_power: float = 9

## How far the player jumps forwards while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var walljump_horizontal_power: float = -6

## How far the player jumps away from the wall while wall-running.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var walljump_kick_power: float = 12


@export_group("Grapple Hooking", "grapple_hook_")

## Can the player grapple hook?
@export var grapple_hook_enabled: bool = true

## How fast the player is pulled towards the grapple point when grapple hooking.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m/s") var grapple_hook_power: float = 8

## How close to the grapple point the player must be to grapple to it.
@export_range(0, 100, 0.05, "or_less", "or_greater", "suffix:m") var grapple_hook_max_distance: float = 15


@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

@onready var head: Node3D = $Head

@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var uncrouch_area: Area3D = $UncrouchArea

@onready var airborne_uncrouch_area: Area3D = $AirborneUncrouchArea

@onready var grapple_hook_raycast: RayCast3D = $Head/Camera/GrappleHookRaycast

@onready var footsteps_audio: AudioStreamPlayer = $FootstepsAudio

@onready var slide_audio: AudioStreamPlayer = $SlideAudio

@onready var grapple_hook_indicator_audio: AudioStreamPlayer = $GrappleHookIndicatorAudio

@onready var grapple_hook_fire_audio: AudioStreamPlayer = $GrappleHookFireAudio


@onready var standing_height: float = collision_shape.shape.height

@onready var standing_head_y: float = head.position.y


enum Stances {STANDING, CROUCHING, SPRINTING}


var move_input_vector: Vector2 = Vector2.ZERO

var move_direction: Vector3 = Vector3.ZERO

var colliding_velocity: Vector3 = Vector3.ZERO


var active_stance: Stances = Stances.SPRINTING

var last_stance: Stances = Stances.STANDING

var crouch_direction: int


var airborne_timestamp: int = 0
var crouch_timestamp: int = 0
var jump_timestamp: int = 0
var slide_timestamp: int = 0
var wallrun_timestamp: int = 0

var coyote_jump_active: bool = false
var coyote_slide_active: bool = false
var coyote_walljump_active: bool = false

var air_jumps: int = 0
var air_crouches: int = 0

var wallrun_wall_normal: Vector3 = Vector3.ZERO
var wallrun_run_direction: Vector3 = Vector3.ZERO

var grapple_hook_point: GrappleHookPoint


func _ready() -> void:
	airborne_uncrouch_area.position.y -= (1 - crouch_height_multiplier) * standing_height
	
	spawn_random()


func _unhandled_input(_event: InputEvent) -> void:
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
	
	if Input.is_action_just_pressed("move_forward"):
		move_input_vector.y = -1
	elif Input.is_action_just_released("move_forward"):
		move_input_vector.y = 1 if Input.is_action_pressed("move_back") else 0
	elif Input.is_action_just_pressed("move_back"):
		move_input_vector.y = 1
	elif Input.is_action_just_released("move_back"):
		move_input_vector.y = -1 if Input.is_action_pressed("move_forward") else 0
	
	if Input.is_action_just_pressed("move_right"):
		move_input_vector.x = 1
	elif Input.is_action_just_released("move_right"):
		move_input_vector.x = -1 if Input.is_action_pressed("move_left") else 0
	elif Input.is_action_just_pressed("move_left"):
		move_input_vector.x = -1
	elif Input.is_action_just_released("move_left"):
		move_input_vector.x = 1 if Input.is_action_pressed("move_right") else 0


func _physics_process(delta: float) -> void:
	move_direction = basis * Vector3(move_input_vector.x, 0, move_input_vector.y).normalized()
	
	state_machine.physics_update(delta)
	
	floor_block_on_wall = is_on_floor()
	colliding_velocity = velocity
	move_and_slide()
	
	if not is_on_floor():
		velocity = get_real_velocity()


func _process(delta: float) -> void:
	state_machine.update(delta)


## Returns how much the player is moving backwards.[br]
## 0: Player is strafing or moving forwards[br]
## 0 - 1: Player is moving diagonally backwards[br]
## 1: Player is moving directly backwards
func get_amount_moving_backwards() -> float:
	return maxf(0, move_direction.dot(basis.z))


## Returns the forward direction of the player.
func get_forward_direction() -> Vector3:
	return -basis.z


## Returns the looking direction of the player.
func get_looking_direction() -> Vector3:
	return -head.global_basis.z


## Returns the position of the player's center of mass.
func get_center_of_mass() -> Vector3:
	return collision_shape.global_position


## This is used to update the is_on_floor, is_on_wall, and is_on_ceiling methods when the player's position has been manually changed
func update_surface_checks() -> void:
	var player_velocity: Vector3 = velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = player_velocity


func spawn_random() -> void:
	var spawn_nodes: Array[Node] = get_tree().get_nodes_in_group("PlayerSpawnPoints").filter(func(node: Node) -> bool: return node is PlayerSpawnPoint)
	
	if not spawn_nodes.is_empty():
		var spawn_node: Node3D = spawn_nodes.pick_random()
		
		position = spawn_node.position
		velocity = Vector3.ZERO
		
		rotation.y = spawn_node.rotation.y
		head.rotation.x = spawn_node.rotation.x
	
	update_surface_checks()
	
	if is_on_floor():
		state_machine.transition(&"Grounded")
	else:
		state_machine.transition(&"Airborne")


func switch_stance(stance: Stances) -> void:
	if stance != active_stance:
		last_stance = active_stance
		active_stance = stance


func crouch() -> void:
	if active_stance == Stances.CROUCHING:
		return
	
	switch_stance(Stances.CROUCHING)
	crouch_timestamp = Time.get_ticks_msec()
	
	collision_shape.shape.height = standing_height * crouch_height_multiplier
	collision_shape.position.y = standing_height * crouch_height_multiplier / 2
	
	if state_machine.active_state is PlayerAirborneState or state_machine.active_state is PlayerJumpingState:
		position.y += standing_height / 2
		head.position.y -= standing_height / 2
		crouch_direction = 1
	else:
		crouch_direction = 0


func attempt_uncrouch() -> bool:
	if active_stance != Stances.CROUCHING:
		return true
	
	if crouch_direction == 1 and not airborne_uncrouch_area.has_overlapping_bodies():
		switch_stance(last_stance)
		crouch_timestamp = Time.get_ticks_msec()
		
		collision_shape.shape.height = standing_height
		collision_shape.position.y = standing_height / 2
		
		position.y -= standing_height / 2
		head.position.y += standing_height / 2
		
		return true
	
	if not uncrouch_area.has_overlapping_bodies():
		switch_stance(last_stance)
		crouch_timestamp = Time.get_ticks_msec()
		
		collision_shape.shape.height = standing_height
		collision_shape.position.y = standing_height / 2
		
		return true
	
	return false


func get_targeted_grapple_hook_point() -> GrappleHookPoint:
	var grapple_hook_points: Array[GrappleHookPoint] = []
	
	while grapple_hook_raycast.is_colliding():
		var collider: CollisionObject3D = grapple_hook_raycast.get_collider()
		if collider is GrappleHookPoint:
			grapple_hook_points.push_back(collider)
		
		grapple_hook_raycast.add_exception(collider)
		grapple_hook_raycast.force_raycast_update()
	
	if grapple_hook_points.is_empty():
		return null
	
	grapple_hook_raycast.clear_exceptions()
	
	var highest_proximity_to_crosshair: float = -1
	
	var highest_proximity_point: GrappleHookPoint
	
	for i: int in grapple_hook_points.size():
		var proximity_to_crosshair: float = head.global_position.direction_to(grapple_hook_points[i].position).dot(get_looking_direction())
		
		if proximity_to_crosshair > highest_proximity_to_crosshair:
			highest_proximity_to_crosshair = proximity_to_crosshair
			highest_proximity_point = grapple_hook_points[i]
	
	return highest_proximity_point


func clear_grapple_hook_point() -> void:
	if grapple_hook_point:
		grapple_hook_point.targeted = grapple_hook_point.NotTargeted
		grapple_hook_point = null


func add_gravity(delta: float, gravity: float) -> void:
	velocity += Vector3.DOWN * gravity * delta


func add_air_resistence(delta: float, air_resistence: float) -> void:
	var current_speed: float = velocity.length()
	
	velocity = velocity.move_toward(Vector3.ZERO, air_resistence * current_speed * delta)


func add_friction(delta: float, friction: float, top_speed: float) -> void:
	var friction_direction: Vector3 = -velocity.normalized()
	
	# When friction direction and movement direction oppose each other, dot product = -1, +1 = 0
	# Clamp between 0 and 1 to not apply more friction when friction direction aligns with movement direction
	var friction_product: float = minf(friction_direction.dot(move_direction) + 1, 1)
	
	# If player is faster than the top speed they can move at, it will always apply friction. A reduced amount if going against the movement direction
	var current_speed: float = velocity.length()
	
	if current_speed > top_speed:
		var scaled_friction_product: float = lerpf(move_friction_multiplier, 1, friction_product)
		
		velocity = velocity.move_toward(velocity.limit_length(top_speed), friction * delta * scaled_friction_product)
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
	
	var old_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	velocity += move_direction * acceleration * delta
	var new_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	
	if new_horizontal_speed <= old_horizontal_speed:
		return
	
	if new_horizontal_speed <= top_speed:
		return
	
	var limited_velocity: Vector3
	
	if old_horizontal_speed <= top_speed:
		limited_velocity = Vector3(velocity.x, 0, velocity.z).limit_length(top_speed)
	else:
		limited_velocity = Vector3(velocity.x, 0, velocity.z).limit_length(old_horizontal_speed)
	
	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.z


func add_wallrun_movement(delta: float) -> void:
	var direction: Vector3 = wallrun_run_direction * -move_input_vector.y
	
	var old_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	velocity += direction * wallrun_acceleration * delta
	var new_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	
	if new_horizontal_speed <= old_horizontal_speed:
		return
	
	if new_horizontal_speed <= wallrun_top_speed:
		return
	
	var limited_velocity: Vector2
	
	if old_horizontal_speed <= wallrun_top_speed:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(wallrun_top_speed)
	else:
		limited_velocity = Vector2(velocity.x, velocity.z).limit_length(old_horizontal_speed)
	
	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.y


func jump() -> void:
	var backwards_multiplier: float = lerpf(1, jump_backwards_multiplier, get_amount_moving_backwards())
	var standing_multiplier: float = lerpf(jump_standing_multiplier, 1, move_direction.length())
	
	# Speed Jumping
	var current_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	var weight: float = clampf((current_horizontal_speed - speed_jump_base_speed) / (speed_jump_max_speed - speed_jump_base_speed), 0, 1)
	
	var power: float = lerpf(jump_power, speed_jump_max_power, weight) * standing_multiplier
	var horizontal_power: float = lerpf(jump_horizontal_power, speed_jump_max_horizontal_power, weight) * backwards_multiplier
	
	velocity.y += power
	
	velocity += move_direction * horizontal_power


func air_jump() -> void:
	velocity = Vector3.ZERO
	air_jumps += 1
	
	var backwards_multiplier: float = lerpf(1, jump_backwards_multiplier, get_amount_moving_backwards())
	var standing_multiplier: float = lerpf(jump_standing_multiplier, 1, move_direction.length())
	
	# Speed Jumping
	var current_horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	var weight: float = clampf((current_horizontal_speed - speed_jump_base_speed) / (speed_jump_max_speed - speed_jump_base_speed), 0, 1)
	
	var power: float = lerpf(jump_power, speed_jump_max_power, weight) * standing_multiplier
	var horizontal_power: float = air_jump_horizontal_power * backwards_multiplier
	
	velocity.y = power
	
	velocity += move_direction * horizontal_power


func slide_jump() -> void:
	velocity.y += slide_jump_power
	
	velocity += velocity.normalized() * slide_jump_horizontal_power


func wall_jump() -> void:
	velocity.y = walljump_power
	
	velocity += Vector3(velocity.x, 0, velocity.z).normalized() * walljump_horizontal_power
	
	velocity += wallrun_wall_normal * walljump_kick_power
