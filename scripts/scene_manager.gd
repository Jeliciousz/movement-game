class_name SceneManager
extends Node

@export_file("*.tscn") var initial_3d_scene: String
@export_file("*.tscn") var initial_ui_scene: String

var current_3d_scene: Node
var current_ui_scene: Node


func _ready() -> void:
	Global.scene_manager = self

	if initial_3d_scene:
		var new_scene: Node = load(initial_3d_scene).instantiate()
		add_child(new_scene)
		current_3d_scene = new_scene

	if initial_ui_scene:
		var new_scene: Node = load(initial_ui_scene).instantiate()
		add_child(new_scene)
		current_ui_scene = new_scene


func change_3d_scene(new_scene_path: String) -> void:
	if current_3d_scene:
		current_3d_scene.queue_free()

	var new_scene: Node3D = load(new_scene_path).instantiate()
	add_child(new_scene)
	current_3d_scene = new_scene


func change_ui_scene(new_scene_path: String) -> void:
	if current_ui_scene:
		current_ui_scene.queue_free()

	var new_scene: Control = load(new_scene_path).instantiate()
	add_child(new_scene)
	current_ui_scene = new_scene


func unload_3d_scene() -> void:
	if current_3d_scene:
		current_3d_scene.queue_free()


func unload_ui_scene() -> void:
	if current_ui_scene:
		current_ui_scene.queue_free()
