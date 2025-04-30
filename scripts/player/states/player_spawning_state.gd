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

		_player.reset_physics_interpolation()

		shared_vars[&"coyote_jump_active"] = false
		shared_vars[&"coyote_slide_active"] = false
		shared_vars[&"coyote_walljump_active"] = false
		shared_vars[&"air_jumps"] = Global.MAX_INT
		shared_vars[&"air_crouches"] = Global.MAX_INT
		shared_vars[&"airborne_timestamp"] = 0
		shared_vars[&"jump_timestamp"] = 0
		shared_vars[&"slide_timestamp"] = 0
		shared_vars[&"wallrun_timestamp"] = 0
		shared_vars[&"wallrun_wall_normal"] = Vector3.ZERO
		shared_vars[&"wallrun_run_direction"] = Vector3.ZERO
		shared_vars[&"grapple_hook_point"] = null
		shared_vars[&"grapple_hook_point_in_range"] = false
		shared_vars[&"ledge_grab_velocity"] = Vector3.ZERO

		InputBuffer.clear_buffered_action("jump")
		InputBuffer.clear_buffered_action("sprint")
		InputBuffer.clear_buffered_action("slide")
		InputBuffer.clear_buffered_action("grapple_hook")

	_player.check_surface(-_player.up_direction)

	if _player.is_on_floor():
		state_machine.change_state_to(&"Grounded")
	else:
		state_machine.change_state_to(&"Airborne")
