extends Node3D

@export var player: Player

@export_file("*.tscn") var menu_scene_path: String
@export_file("*.tscn") var first_level_path: String


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var scene: Node3D = load(first_level_path).instantiate()
	add_child(scene)

	player.spawn()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action(&"ui_cancel") and event.pressed and not event.echo:
		Global.scene_manager.change_scene(menu_scene_path)
