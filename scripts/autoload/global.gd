extends Node
## The Global Autoload.

const MAX_INT: int = 9223372036854775807
const MIN_INT: int = -9223372036854775808


func _init() -> void:
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
