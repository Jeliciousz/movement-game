class_name Player extends CharacterBody3D


@export_group("Physics")

@export var friction: float = 40
@export var air_resistence: float = 0.2
@export var gravity: float = 30

@export_group("Movement")

@export var top_speed: float = 4
@export var acceleration: float = 80

@export_group("Air Control")

@export var airborne_speed_multiplier: float = 0.35
@export var airborne_acceleration_multiplier: float = 0.35

@export_group("Jumping")

@export var jump_power: float = 8
@export var jump_horizontal_power: float = 3
@export var jump_standing_multiplier: float = 1.2
@export var jump_duration: float = 1.5
@export var jump_gravity_multiplier: float = 0.7
@export var jump_coyote_time: float = 0.15
@export var jump_buffer_duration: float = 0.1

@export_group("Sprinting")

@export var sprint_speed_multiplier: float = 1.5
@export var sprint_jump_multiplier: float = 1.2


var input_axis: Vector2 = Vector2.ZERO
var move_direction: Vector3 = Vector3.ZERO
var jump_action_timer: float = 999
var airborne_timer: float = 0
var jump_timer: float = 0

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
	if Input.is_action_just_pressed("forward"):
		input_axis.y = -1
	if Input.is_action_just_pressed("back"):
		input_axis.y = 1
	if Input.is_action_just_pressed("left"):
		input_axis.x = -1
	if Input.is_action_just_pressed("right"):
		input_axis.x = 1
	
	if Input.is_action_just_released("forward"):
		input_axis.y = float(Input.is_action_pressed("back"))
	if Input.is_action_just_released("back"):
		input_axis.y = -float(Input.is_action_pressed("forward"))
	if Input.is_action_just_released("left"):
		input_axis.x = float(Input.is_action_pressed("right"))
	if Input.is_action_just_released("right"):
		input_axis.x = -float(Input.is_action_pressed("left"))
	
	if Input.is_action_just_pressed("jump"):
		jump_action_timer = 0


func _process(delta: float) -> void:
	move_direction = (transform.basis * Vector3(input_axis.x, 0, input_axis.y)).normalized()
	jump_action_timer += delta


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if position.y < -10:
		position = Vector3.ZERO


func add_gravity(delta: float, gravity: float = gravity) -> void:
	velocity.y -= gravity * delta


func add_air_resistence(delta: float) -> void:
	velocity = velocity.move_toward(Vector3.ZERO, air_resistence * speed * delta)


func add_friction(delta: float) -> void:
	if speed > top_speed:
		velocity = velocity.move_toward(velocity.limit_length(top_speed), friction * delta)
		return
	
	var friction_direction = -velocity_direction
	
	var friction_product = minf(friction_direction.dot(move_direction) + 1, 1)
	
	velocity = velocity.move_toward(Vector3.ZERO, friction * friction_product * delta)


func add_movement(delta: float, top_speed: float = top_speed, acceleration: float = acceleration) -> void:
	var old_horizontal_speed = horizontal_speed
	var new_velocity = velocity + move_direction * acceleration * delta
	var new_horizontal_speed = Vector2(new_velocity.x, new_velocity.z).length()
	
	if new_horizontal_speed <= top_speed:
		velocity = new_velocity
		return
	
	if old_horizontal_speed <= top_speed:
		var limited_velocity = Vector2(new_velocity.x, new_velocity.z).limit_length(top_speed)
		velocity.x = limited_velocity.x
		velocity.z = limited_velocity.y
		
		return
	
	var limited_velocity = Vector2(new_velocity.x, new_velocity.z).limit_length(old_horizontal_speed)
	velocity.x = limited_velocity.x
	velocity.z = limited_velocity.y


func jump(cancel_velocity: bool = false, jump_power: float = jump_power, jump_horizontal_power: float = jump_horizontal_power) -> void:
	jump_timer = 0
	
	if cancel_velocity:
		velocity.y = 0
	
	if move_direction.is_zero_approx():
		velocity.y += jump_power * jump_standing_multiplier
		return
	
	velocity.y += jump_power
	
	var move_product = maxf(move_direction.dot(-transform.basis.z), 0)
	velocity += move_direction * jump_horizontal_power * move_product
