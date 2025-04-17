extends Area3D


var explosion = preload("res://scenes/explosion.tscn")


var velocity: Vector3 = Vector3.DOWN * 14


func _physics_process(delta: float) -> void:
	position += velocity * delta
	
	if not has_overlapping_bodies():
		return
	
	for body in get_overlapping_bodies():
		if body.collision_layer == 1:
			var blast = explosion.instantiate()
			blast.global_position = global_position
			get_tree().root.add_child(blast)
			queue_free()
			return
