extends Node


const BUFFER_WINDOW: int = 150


const buffered_actions: Array[String] = ["jump", "crouch", "sprint"]


var action_timestamps: Dictionary[String, int] = {}


func _physics_process(delta: float) -> void:
	for action in buffered_actions:
		if Input.is_action_just_pressed(action):
			action_timestamps[action] = Time.get_ticks_msec()


func is_action_buffered(action: String) -> bool:
	if not action_timestamps.has(action):
		return false
	
	var buffered = Time.get_ticks_msec() - action_timestamps[action] <= BUFFER_WINDOW
	
	action_timestamps.erase(action)
	
	return buffered
