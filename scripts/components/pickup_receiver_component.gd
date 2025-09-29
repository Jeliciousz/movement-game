class_name PickupReceiverComponent
extends Area3D
## The pickup receiving area for an entity.

## Emitted when a pickup is received.
signal pickup_received(pickup: Node3D)


func _on_area_entered(area: Area3D) -> void:
	if not area is PickupComponent:
		return

	var pickup_collect_component: PickupComponent = area

	if not pickup_collect_component.enabled:
		return

	pickup_collect_component.collect()

	pickup_received.emit(pickup_collect_component.get_parent_node_3d().duplicate())
