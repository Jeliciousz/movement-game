class_name PlayerSpawnPoint
extends Node3D
## A point the [Player] can spawn at.

@export var spawn_stance: Player.Stances


func _init() -> void:
	hide()
