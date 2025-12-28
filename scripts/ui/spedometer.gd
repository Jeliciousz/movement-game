extends Label

const LERP_RATE: float = 20.0

var current_displayed_speed: float = 0.0

@onready var player: Player = get_parent().player


func _ready() -> void:
	player.spawned.connect(reset_spedometer)


func _process(delta: float) -> void:
	var horizontal_speed: float = player.get_horizontal_speed() * 3.6

	current_displayed_speed = lerpf(current_displayed_speed, horizontal_speed, LERP_RATE * delta)

	text = "%.f KPH" % current_displayed_speed


func reset_spedometer() -> void:
	current_displayed_speed = player.get_horizontal_speed() * 3.6
