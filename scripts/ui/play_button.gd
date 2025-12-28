extends Button

var game_scene: PackedScene = preload("res://scenes/levels/test.tscn")


func _on_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_packed(game_scene)
