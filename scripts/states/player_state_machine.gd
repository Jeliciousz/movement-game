class_name PlayerStateMachine extends StateMachine


@export var player: Player


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	
	player.move_and_slide()
	
	if player.position.y < -100:
		player.position = Vector3.ZERO
