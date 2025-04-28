extends Camera3D

## The world camera to transform the viewmodel camera to.
@export var _world_camera: Camera3D


func _process(_delta: float) -> void:
	transform = _world_camera.transform
