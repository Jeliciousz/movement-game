class_name KillArea
extends Area3D
## If an entity with a health component enters this area, they will die.


func _on_body_entered(body: PhysicsBody3D) -> void:
	if not body.has_node(^"HealthComponent"):
		return

	var health_component: HealthComponent = body.get_node(^"HealthComponent")

	health_component.kill()
