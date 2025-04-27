extends Label

@export var _player: Player


func _process(_delta: float) -> void:
	var stance_as_text: String

	match _player._stance:
		_player.Stances.STANDING:
			stance_as_text = "Standing"

		_player.Stances.CROUCHING:
			stance_as_text = "Crouching"

		_player.Stances.SPRINTING:
			stance_as_text = "Sprinting"

	text = "Active state: %s\nActive stance: %s\nCoyote jump active: %s\nCoyote slide active: %s\nCoyote wall-jump active: %s" % [_player.state_machine.active_state_name, stance_as_text, _player._coyote_jump_active, _player.coyote_slide_active, _player.coyote_walljump_active]
