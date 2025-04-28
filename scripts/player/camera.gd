extends Camera3D

@export var _player: Player


func _process(_delta: float) -> void:
	var interpolated_transform: Transform3D = _player.head.get_global_transform_interpolated()

	position = interpolated_transform.origin
	basis = _player.head.global_basis
