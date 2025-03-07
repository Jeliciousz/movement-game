extends Label


@export var player: Player


func _process(_delta: float) -> void:
	text = "%.fkm/h" % (player.horizontal_speed * 3.6)
