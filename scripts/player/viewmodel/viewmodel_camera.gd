extends Camera3D


@export var world_camera: Camera3D


func _physics_process(_delta: float) -> void:
	global_transform = world_camera.global_transform
