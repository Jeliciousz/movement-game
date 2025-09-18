class_name MouseAimController
extends Node
## Rotates a body and a head for FPS camera control with the mouse.
##
## Code courtesy of [url=https://yosoyfreeman.github.io/article/godot/tutorial/achieving-better-mouse-input-in-godot-4-the-perfect-camera-controller/]Yo Soy Freeman[/url]. Edited by Jeliciousz

## How many radians should the camera rotate per dot of mouse movement.
const RADIANS_PER_DOT: float = deg_to_rad(0.1)

## Settings.
@export_group("Settings")

## Mouse settings.
@export_subgroup("Mouse")

## How sensitive aiming is.
@export var sensitivity: Vector2 = Vector2(1.0, 1.0)

## Camera pitch clamping.
@export_subgroup("Clamping")

## Maximum camera pitch in radians.
@export_range(0, 90, 0.5, "radians_as_degrees") var max_pitch: float = deg_to_rad(89.9)

## Minimum camera pitch in radians.
@export_range(-90, 0, 0.5, "radians_as_degrees") var min_pitch: float = deg_to_rad(-89.9)

## Node references.
@export_group("Nodes")

## The body.
@export var _body: Node3D

## The head.
@export var _head: Node3D


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		aim(event)


## Handles aiming with the mouse.
func aim(event: InputEventMouseMotion) -> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative

	motion *= RADIANS_PER_DOT
	motion *= sensitivity

	add_yaw(motion.x)
	add_pitch(motion.y)
	clamp_pitch()


## Rotates the body around the local Y axis by a given amount (in radians) to achieve yaw.
func add_yaw(amount: float) -> void:
	if is_zero_approx(amount):
		return

	_body.rotate_object_local(Vector3.DOWN, amount)
	_body.orthonormalize()


## Rotates the head around the local x axis by a given amount (in radians) to achieve pitch.
func add_pitch(amount: float) -> void:
	if is_zero_approx(amount):
		return

	_head.rotate_object_local(Vector3.LEFT, amount)
	_head.orthonormalize()


## Clamps the pitch between min_pitch and max_pitch.
func clamp_pitch() -> void:
	if _head.rotation.x > min_pitch and _head.rotation.x < max_pitch:
		return

	_head.rotation.x = clamp(_head.rotation.x, min_pitch, max_pitch)
	_head.orthonormalize()
