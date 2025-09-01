class_name PlayerSpawningState
extends State
## Active when the [Player] spawns.

## The [Player].
@export var _player: Player


func _state_physics_preprocess(_delta: float) -> void:
	spawn_random()


func spawn_random() -> void:
	var spawn_nodes: Array[Node] = get_tree().get_nodes_in_group(&"PlayerSpawnPoints").filter(func(node: Node) -> bool: return node is PlayerSpawnPoint and node.enabled)

	if not spawn_nodes.is_empty():
		var spawn_node: PlayerSpawnPoint = spawn_nodes.pick_random()

		_player.position = spawn_node.position
		_player.rotation.y = spawn_node.rotation.y
		_player.head.rotation.x = spawn_node.rotation.x
	else:
		_player.position = Vector3.ZERO
		_player.rotation.y = 0.0
		_player.head.rotation.x = 0.0

	_player.velocity = Vector3.ZERO
	_player.reset_physics_interpolation()

	if _player.active_grapple_hook_point:
		clear_grapple_hook_point()

	InputBuffer.clear_buffered_action("jump")
	InputBuffer.clear_buffered_action("sprint")
	InputBuffer.clear_buffered_action("slide")
	InputBuffer.clear_buffered_action("grapple_hook")

	if _player.check_surface(-_player.up_direction):
		state_machine.change_state_to(&"Grounded")
	else:
		state_machine.change_state_to(&"Airborne")


func clear_grapple_hook_point() -> void:
	if _player.active_grapple_hook_point:
		_player.active_grapple_hook_point.targeted = GrappleHookPoint.Target.NOT_TARGETED
		_player.active_grapple_hook_point = null
