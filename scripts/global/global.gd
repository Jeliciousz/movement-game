extends Node
## The Global Autoload.

const MAX_INT: int = 9223372036854775807
const MIN_INT: int = -9223372036854775808

var time: float = 0.0


func _init() -> void:
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action(&"ui_cancel") and event.pressed and not event.echo:
			get_tree().quit()


func _physics_process(delta: float) -> void:
	time += delta


func reset_time() -> void:
	time = 0.0
