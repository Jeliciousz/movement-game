extends Node3D

@export var player: Player


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var scene: Node3D = preload("res://scenes/levels/test.tscn").instantiate()
	add_child(scene)

	player.spawn()
