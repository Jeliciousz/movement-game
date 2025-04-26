extends Camera3D


## The world camera to transform the viewmodel camera to.
@export var world_camera: Camera3D


func _physics_process(_delta: float) -> void:
	global_transform = world_camera.global_transform
