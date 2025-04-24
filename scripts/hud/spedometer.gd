extends Label


@export var player: Player


func _process(_delta: float) -> void:
	var horizontal_speed = Vector2(player.velocity.x, player.velocity.z).length()
	text = "%.fkph" % (horizontal_speed * 3.6)
