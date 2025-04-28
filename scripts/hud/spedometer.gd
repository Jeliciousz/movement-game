extends Label

## The [Player].
@export var _player: Player

## How quickly the speed shown on the spedometeter updates to match the player's speed.
@export var _speed_track_rate: float = 100.0

var _label_speed: float = 0.0


func _process(delta: float) -> void:
	# Kilometers Per Hour
	var horizontal_speed: float = Vector2(_player.velocity.x, _player.velocity.z).length() * 3.6

	_label_speed = move_toward(_label_speed, horizontal_speed, _speed_track_rate * delta)

	text = "%.f kph" % _label_speed
