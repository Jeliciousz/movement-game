class_name Dodgeball
extends RigidBody3D
## The dodgeball.


func _on_pickup_collect_component_pickup_collected() -> void:
	queue_free()
