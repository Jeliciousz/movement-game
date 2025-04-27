extends Label

## The [Player].
@export var _player: Player

## How quickly the speed shown on the spedometeter updates to match the player's speed.
@export var _speed_track_rate: float = 100.0

var _label_speed_kph: float = 0.0


func _process(delta: float) -> void:
	var horizontal_speed_kph: float = Vector2(_player.velocity.x, _player.velocity.z).length() * 3.6

	_label_speed_kph = move_toward(_label_speed_kph, horizontal_speed_kph, _speed_track_rate * delta)

	text = "%.f kph" % _label_speed_kph
