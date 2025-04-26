extends Label


@export var player: Player


var label_speed: float = 0


func _process(delta: float) -> void:
	var horizontal_speed: float = Vector2(player.velocity.x, player.velocity.z).length()

	label_speed = lerpf(label_speed, horizontal_speed, 15 * delta)

	text = "%.fkph" % (label_speed * 3.6)
