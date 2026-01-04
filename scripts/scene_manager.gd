class_name SceneManager
extends Node

@export_file("*.tscn") var initial_scene: String

var current_scene: Node


func _ready() -> void:
	Global.scene_manager = self

	if initial_scene:
		var new_scene: Node = load(initial_scene).instantiate()
		get_tree().root.add_child.call_deferred(new_scene)
		current_scene = new_scene


func change_scene(new_scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()

	var new_scene: Node = load(new_scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
