extends Label

@onready var player: Player = get_parent().player


func _process(_delta: float) -> void:
	text = "Active state: %s\n" % player.state_machine.get_state_name() \
	+ "Active stance: %s" % player.stance_to_string()
