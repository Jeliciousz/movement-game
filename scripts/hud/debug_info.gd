extends Label

## The [Player].
@export var _player: Player


func _process(_delta: float) -> void:
	text = "Active state: %s \n " % _player.state_machine.get_state_name()\
	+ "Active stance: %s" % _player.get_stance_as_text()
