class_name QuitConfirmationDialog
extends Control

@export var dim_background: ColorRect


func _ready() -> void:
	dim_background.hide()
	hide()


func prompt_quit() -> void:
	dim_background.show()
	show()


func _on_confirm_quit_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_quit_button_pressed() -> void:
	dim_background.hide()
	hide()
