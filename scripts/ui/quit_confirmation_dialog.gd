class_name QuitConfirmationDialog
extends Control


func _ready() -> void:
	hide()


func prompt_quit() -> void:
	show()


func _on_confirm_quit_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_quit_button_pressed() -> void:
	hide()
