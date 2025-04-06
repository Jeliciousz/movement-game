extends Node


@export var player: Player

@export var player_state_machine: StateMachine


@export var player_head: Node3D
@export var player_mesh: Node3D

var standing_head_y: float
var standing_mesh_y: float


func _ready() -> void:
	standing_head_y = player_head.position.y
	standing_mesh_y = player_mesh.position.y


func _process(_delta: float) -> void:
	var weight: float = minf(float(Time.get_ticks_msec() - player.crouch_timestamp) / float(player.crouch_transition_time), 1)
	
	if player_state_machine.current_state.name == &"PlayerCrouching" or player_state_machine.current_state.name == &"PlayerSliding":
		player_mesh.scale.y = lerpf(1, player.crouch_height_multiplier, weight)
		player_mesh.position.y = lerpf(standing_mesh_y, standing_mesh_y * player.crouch_height_multiplier, weight)
		player_head.position.y = lerpf(standing_head_y, standing_head_y * player.crouch_height_multiplier, weight)
	else:
		player_mesh.scale.y = lerpf(player.crouch_height_multiplier, 1, weight)
		player_mesh.position.y = lerpf(standing_mesh_y * player.crouch_height_multiplier, standing_mesh_y, weight)
		player_head.position.y = lerpf(standing_head_y * player.crouch_height_multiplier, standing_head_y, weight)
