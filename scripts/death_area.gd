class_name DeathArea
extends Area3D
## If a [Player] enters this area, they will die.


func _physics_process(_delta: float) -> void:
	if not has_overlapping_bodies():
		return

	for player: Player in get_overlapping_bodies():
		if not player is Player:
			continue

		player.kill()
