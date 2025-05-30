class_name PickupReceiverComponent
extends Area3D
## The pickup receiving area for an entity.

## Emitted when a pickup is received.
signal pickup_received(pickup: Node3D)

@export_flags("A", "B", "C", "D", "E", "F", "G", "H") var collection_mask: int = 0


func _on_area_entered(area: Area3D) -> void:
	if not area is PickupCollectComponent:
		return

	var pickup_collect_component: PickupCollectComponent = area

	if not pickup_collect_component.enabled:
		return

	if pickup_collect_component.collection_layer & collection_mask == 0:
		return

	pickup_collect_component.collect()

	pickup_received.emit(pickup_collect_component.get_parent_node_3d().duplicate())
