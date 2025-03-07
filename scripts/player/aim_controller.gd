extends Node


# Code courtesy of Yo Soy Freeman | https://yosoyfreeman.github.io/article/godot/tutorial/achieving-better-mouse-input-in-godot-4-the-perfect-camera-controller/
# Slightly edited by Jeliciousz


@export_group("Nodes")

## The Player.
@export var player: Player

## The head.
@export var head: Node3D


## Settings.
@export_group("Settings")

## Mouse settings.
@export_subgroup("Mouse")

@export_range(0.01, 1.00) var mouse_sensitivity: float = 0.5


## Camera pitch clamping.
@export_subgroup("Clamping")

## Maximum camera pitch in degrees.
@export_range(0, 89.99) var max_pitch: float = 89.99

## Minimum camera pitch in degrees.
@export_range(-89.99, 0) var min_pitch: float = -89.99


func _ready():
	Input.set_use_accumulated_input(false)


func _unhandled_input(event: InputEvent)-> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		if event is InputEventKey:
			if event.is_action_pressed("ui_cancel"):
				get_tree().quit()
				
		if event is InputEventMouseButton:
			if event.button_index == 1:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
		return
	
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		return
	
	if event is InputEventMouseMotion:
		aim_look(event)


## Handles aim look with the mouse.
func aim_look(event: InputEventMouseMotion) -> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.25
	
	motion *= degrees_per_unit
	motion *= mouse_sensitivity
	
	add_yaw(motion.x)
	add_pitch(motion.y)
	clamp_pitch()


## Rotates the character around the local Y axis by a given amount (In degrees) to achieve yaw.
func add_yaw(amount: float) -> void:
	if is_zero_approx(amount):
		return
	
	player.rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	player.orthonormalize()


## Rotates the head around the local x axis by a given amount (In degrees) to achieve pitch.
func add_pitch(amount: float) -> void:
	if is_zero_approx(amount):
		return
	
	head.rotate_object_local(Vector3.LEFT, deg_to_rad(amount))
	head.orthonormalize()


## Clamps the pitch between min_pitch and max_pitch.
func clamp_pitch() -> void:
	if head.rotation.x > deg_to_rad(min_pitch) and head.rotation.x < deg_to_rad(max_pitch):
		return
	
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	head.orthonormalize()
