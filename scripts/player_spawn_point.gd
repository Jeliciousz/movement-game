class_name PlayerSpawnPoint
extends Node3D
## A point the [Player] can spawn at.

## Is this spawn point enabled?
@export var enabled: bool = true

## What stance the player will start in when they spawn here.
@export var spawn_stance: Player.Stances


func _init() -> void:
	hide()
