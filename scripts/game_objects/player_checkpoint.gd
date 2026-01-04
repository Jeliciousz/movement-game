class_name PlayerCheckpoint
extends Area3D
## Enables and disables spawn points when the [Player] enters the area.

## Is this checkpoint enabled?
@export var enabled: bool = true

## Should this checkpoint disable itself once the player reaches it?
@export var disable_on_reach: bool = true

## The [PlayerSpawnPoint]s this checkpoint should enable after disable all enabled checkpoints.
@export var spawn_points: Array[PlayerSpawnPoint]


func _init() -> void:
	hide()


func _on_body_entered(body: Node3D) -> void:
	print("fucker")

	if not enabled:
		return

	if not body is Player:
		return

	var spawn_nodes: Array[Node] = get_tree().get_nodes_in_group(&"PlayerSpawnPoints").filter(func(node: Node) -> bool: return node is PlayerSpawnPoint and node.enabled)

	for spawn_node in spawn_nodes:
		spawn_node.enabled = false

	for spawn_point in spawn_points:
		spawn_point.enabled = true

	if disable_on_reach:
		enabled = false
