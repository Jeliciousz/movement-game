extends Control

@export_file("*.tscn") var play_scene_path: String

@export var quit_confirmation_dialog: QuitConfirmationDialog


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action(&"ui_cancel") and event.pressed and not event.echo:
		quit_confirmation_dialog.prompt_quit()


func _on_play_button_pressed() -> void:
	Global.game_manager.unload_ui_scene()
	Global.game_manager.change_3d_scene(play_scene_path)


func _on_quit_button_pressed() -> void:
	quit_confirmation_dialog.prompt_quit()
