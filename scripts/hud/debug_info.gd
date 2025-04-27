extends Label

## The [Player].
@export var _player: Player

## The player's [StateMachine].
@export var _state_machine: StateMachine


func _process(_delta: float) -> void:
	text = "Active state: %s\nActive stance: %s\nCoyote jump active: %s\nCoyote slide active: %s\nCoyote wall-jump active: %s" % [_state_machine.get_state_name(), _player.get_stance_as_text(), _state_machine.shared_vars[&"coyote_jump_active"], _state_machine.shared_vars[&"coyote_slide_active"], _state_machine.shared_vars[&"coyote_walljump_active"]]
