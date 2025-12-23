extends Label

## The [Player].
@export var _player: Player

## How quickly the speed shown on the spedometeter updates to match the player's speed.
@export var _spedometer_lerp_speed: float = 20.0

var _label_speed: float = 0.0


func _process(delta: float) -> void:
	var horizontal_speed: float = _player.get_horizontal_velocity().length() * 3.6 # Kilometers Per Hour

	_label_speed = lerpf(_label_speed, horizontal_speed, _spedometer_lerp_speed * delta)

	text = "%.f kph" % _label_speed


func reset_spedometer() -> void:
	_label_speed = _player.get_horizontal_velocity().length() * 3.6	# Kilometers Per Hour
