class_name PlayerSpawn extends State


@export var player: Player
@export var player_head: Node3D


func enter() -> void:
	random_spawn()
	
	player.move_and_slide()
	
	if player.is_on_floor():
		transition.emit(&"PlayerGrounded")
	else:
		transition.emit(&"PlayerAirborne")


func random_spawn() -> void:
	var spawn_nodes: Array[Node] = get_tree().get_nodes_in_group("PlayerSpawnNodes").filter(func(node): return node is Node3D)
	
	if spawn_nodes.is_empty():
		return
	
	var spawn_node: Node3D = spawn_nodes.pick_random()
	
	player.set_position(spawn_node.position)
	player.set_velocity(Vector3.ZERO)
	
	player.rotation.y = spawn_node.rotation.y
	player_head.rotation.x = spawn_node.rotation.x
