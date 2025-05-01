extends Label

## The [Player].
@export var _player: Player


func _process(_delta: float) -> void:
	text = "Active state: %s\nActive stance: %s\nCoyote jump active: %s\nCoyote slide active: %s\nCoyote wall-jump active: %s\nWall-jumps: %s" % [_player.state_machine.get_state_name(), _player.get_stance_as_text(), _player.state_machine.get_shared_var(&"coyote_jump_active"), _player.state_machine.get_shared_var(&"coyote_slide_active"), _player.state_machine.get_shared_var(&"coyote_walljump_active"), _player.state_machine.get_shared_var(&"wall_jumps")]
