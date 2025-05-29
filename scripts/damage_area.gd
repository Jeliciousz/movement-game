class_name DamageArea
extends Area3D
## If an entity with a health component enters this area, it will take damage.

## Should the damage area kill any entities that enter the area.
@export var kill: bool = false
## How much damage the damage area deals.
@export var damage: float = 1.0


func _on_body_entered(body: PhysicsBody3D) -> void:
	if not body.has_node(^"HealthComponent"):
		return

	var health_component: HealthComponent = body.get_node(^"HealthComponent")

	if kill:
		health_component.kill()
	else:
		health_component.damage(damage)
