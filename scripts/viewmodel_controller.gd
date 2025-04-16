extends Node


@export var world_camera: Camera3D

@export var viewmodel_camera: Camera3D

@export var viewmodel_base: Node3D

@export var player: Player


func _process(delta: float) -> void:
	viewmodel_camera.global_transform = world_camera.global_transform
