class_name Dodgeball
extends RigidBody3D
## The dodgeball.


func _on_pickup() -> void:
	queue_free()
