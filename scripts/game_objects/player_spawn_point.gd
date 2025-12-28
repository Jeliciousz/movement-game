class_name PlayerSpawnPoint
extends Node3D
## A point the [Player] can spawn at.

## Is this spawn point enabled?
@export var enabled: bool = true


func _init() -> void:
	hide()
