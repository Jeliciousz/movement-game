extends Node
## The Global Autoload.


func _init() -> void:
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
