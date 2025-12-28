extends Button

@export_file("*.tscn") var level_scene_path: String


func _on_pressed() -> void:
	Global.game_manager.unload_ui_scene()
	Global.game_manager.change_3d_scene(level_scene_path)
