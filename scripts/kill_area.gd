class_name KillArea
extends Area3D
## If an entity with a health component enters this area, they will die.


func _physics_process(_delta: float) -> void:
	for body: PhysicsBody3D in get_overlapping_bodies():
		if not body.has_node(^"HealthComponent"):
			continue

		var health_component: HealthComponent = body.get_node(^"HealthComponent")

		health_component.kill()
