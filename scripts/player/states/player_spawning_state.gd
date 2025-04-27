class_name PlayerSpawningState
extends State
## Active when the [Player] spawns.

## The [Player].
@export var _player: Player


func _state_physics_preprocess(_delta: float) -> void:
	spawn_random()


func spawn_random() -> void:
	var spawn_nodes: Array[Node] = get_tree().get_nodes_in_group(&"PlayerSpawnPoints").filter(func(node: Node) -> bool: return node is PlayerSpawnPoint)

	if not spawn_nodes.is_empty():
		var spawn_node: PlayerSpawnPoint = spawn_nodes.pick_random()

		_player.position = spawn_node.position
		_player.velocity = Vector3.ZERO
		_player.rotation.y = spawn_node.rotation.y
		_player.head.rotation.x = spawn_node.rotation.x

		shared_vars[&"coyote_jump_active"] = false
		shared_vars[&"coyote_slide_active"] = false
		shared_vars[&"coyote_walljump_active"] = false
		shared_vars[&"air_jumps"] = Global.MAX_INT
		shared_vars[&"air_crouches"] = Global.MAX_INT
		shared_vars[&"airborne_timestamp"] = Global.MIN_INT
		shared_vars[&"crouch_timestamp"] = Global.MIN_INT
		shared_vars[&"slide_timestamp"] = Global.MIN_INT
		shared_vars[&"grapple_hook_point"] = null

		InputBuffer.clear_buffered_action("jump")
		InputBuffer.clear_buffered_action("sprint")
		InputBuffer.clear_buffered_action("slide")
		InputBuffer.clear_buffered_action("grapple_hook")

	_player.check_surface(-_player.up_direction)

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
	else:
		state_machine.change_state_to(&"Airborne")
