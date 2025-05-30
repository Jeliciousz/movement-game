class_name PickupCollectComponent
extends Area3D
## The collection area of a pickup entity.

## Emitted when the pickup is collected.
signal pickup_collected()

@export var enabled: bool = true
@export_flags("A", "B", "C", "D", "E", "F", "G", "H") var collection_layer: int = 0


func collect() -> void:
	pickup_collected.emit()
