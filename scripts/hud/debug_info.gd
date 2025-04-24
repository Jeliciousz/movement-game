extends Label


@export var player: Player


func _process(_delta: float) -> void:
	var stance: String
	
	match player.active_stance:
		player.Stances.STANDING:
			stance = "Standing"
		player.Stances.CROUCHING:
			stance = "Crouching"
		player.Stances.SPRINTING:
			stance = "Sprinting"
	
	text = "Active state: %s\nActive stance: %s\nCoyote jump active: %s\nCoyote slide active: %s\nCoyote wall-jump active: %s" % [player.state_machine.active_state_name, stance, player.coyote_jump_active, player.coyote_slide_active, player.coyote_walljump_active]
