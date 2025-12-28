extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action(&"ui_cancel") and event.pressed and not event.echo:
		get_tree().quit()
