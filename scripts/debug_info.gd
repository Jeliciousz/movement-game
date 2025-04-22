extends Label


@export var player: Player


func _process(_delta: float) -> void:
	var state: String
	
	match player.active_state:
		player.States.Grounded:
			state = "grounded"
		player.States.Airborne:
			state = "airborne"
		player.States.Jumping:
			state = "jumping"
		player.States.Sliding:
			state = "sliding"
		player.States.Wallrunning:
			state = "wall-running"
	
	var stance: String
	
	match player.active_stance:
		player.Stances.Standing:
			stance = "standing"
		player.Stances.Crouching:
			stance = "crouching"
		player.Stances.Sprinting:
			stance = "sprinting"
	
	text = "active state: %s\nactive stance: %s\ncoyote jump active: %s\ncoyote slide active: %s" % [state, stance, player.coyote_jump_active, player.coyote_slide_active]
