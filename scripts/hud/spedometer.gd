extends Label


@export var player: Player


func _process(_delta: float) -> void:
	text = "%.1fkm/h" % (player.speed * 3.6)
