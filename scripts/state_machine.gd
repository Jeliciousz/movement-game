class_name StateMachine extends Node


@export var initial_state: State

var states: Dictionary[StringName, State] = {}
var current_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			states.set(child.name, child)
			child.transition.connect(on_child_transition)
	
	if initial_state:
		current_state = initial_state
		current_state.enter()


func _process(delta: float) -> void:
	if current_state:
		current_state.update_state()
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update_physics_state()
		current_state.physics_update(delta)


func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	var old_state_name: StringName = current_state.name
	
	current_state = new_state
	current_state.enter()
