extends StaticBody3D


@export var launch_speed: float = 0


var explosion = preload("res://scenes/explosion.tscn")


func _physics_process(delta: float) -> void:
	if not is_inside_tree():
		return
	
	var collision = move_and_collide(-basis.z * launch_speed * delta)
	
	if not collision:
		return
	
	var blast = explosion.instantiate()
	blast.position = global_position
	get_tree().root.add_child(blast)
	free()
