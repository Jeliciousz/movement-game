extends Node


const BUFFER_WINDOW: int = 125

const buffered_actions: Array[String] = ["jump", "slide"]


var action_timestamps: Dictionary[String, int] = {}

var queued_for_erasure: Array[String] = []


func _physics_process(delta: float) -> void:
	for action in buffered_actions:
		if Input.is_action_just_pressed(action):
			action_timestamps[action] = Time.get_ticks_msec()
			queued_for_erasure.erase(action)
		elif action_timestamps.has(action) and Time.get_ticks_msec() - action_timestamps[action] > BUFFER_WINDOW:
			queued_for_erasure.push_back(action)
	
	if queued_for_erasure.is_empty():
		return
	
	for action in queued_for_erasure:
		action_timestamps.erase(action)
	
	queued_for_erasure.clear()
	


func is_action_buffered(action: String) -> bool:
	if not action_timestamps.has(action):
		return false
	
	queued_for_erasure.push_back(action)
	
	return Time.get_ticks_msec() - action_timestamps[action] <= BUFFER_WINDOW
