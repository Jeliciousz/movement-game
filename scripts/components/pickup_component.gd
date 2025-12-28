class_name PickupComponent
extends Area3D
## A component for objects that can be picked-up.

signal picked_up()
signal dropped()

@export var enabled: bool = true

var _is_picked_up: bool = false


func pickup() -> bool:
	if not enabled:
		return false

	if _is_picked_up:
		return false

	_is_picked_up = true
	return true


func drop() -> void:
	if not enabled:
		return

	if not _is_picked_up:
		return

	_is_picked_up = false


func is_pickup_pickable() -> bool:
	if not enabled:
		return false

	if _is_picked_up:
		return false

	return true

