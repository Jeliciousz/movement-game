extends Node
## Global time affected by delta.

var _time: float = 0.0


func _physics_process(delta: float) -> void:
	_time += delta


func reset_time() -> void:
	_time = 0.0


func get_timestamp() -> float:
	return _time
