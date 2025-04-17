extends StaticBody3D


var explosion = preload("res://scenes/explosion.tscn")


var velocity: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if not collision:
		return
	
	var collider = collision.get_collider()
	
	if not (collider.collision_layer == 1 or collider.collision_layer == 4 or collider.is_in_group(&"OtherPlayers")):
		return
	
	var blast = explosion.instantiate()
	blast.global_position = global_position
	get_tree().root.add_child(blast)
	free()
