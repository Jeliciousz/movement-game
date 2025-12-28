class_name StateMachine
extends Node
## Handles updating and switching between [State]s.

## Emitted when the [StateMachine] changes state.
signal state_changed(last_state: StringName, current_state: StringName)

## The [State] that this [StateMachine] will start in.
@export var initial_state: State

## The currently active state.
@onready var state: State = initial_state


func _ready() -> void:
	if state == null:
		return

	state.state_machine = self
	state._state_enter("")


func _process(delta: float) -> void:
	if state == null:
		return

	state._state_preprocess(delta)

	state._state_process(delta)


func _physics_process(delta: float) -> void:
	if state == null:
		return

	state._state_physics_preprocess(delta)

	state._state_physics_process(delta)


func _input(event: InputEvent) -> void:
	if state == null:
		return

	state._state_input(event)


func _unhandled_input(event: InputEvent) -> void:
	if state == null:
		return

	state._state_unhandled_input(event)


## Returns the name of the current state.
func get_state_name() -> StringName:
	return state.name


## Transition to a new state.
func change_state_to(new_state: StringName) -> void:
	if not has_node(NodePath(new_state)):
		printerr("The StateMachine does not have a child State with the name: '%s'" % new_state)
		return

	var last_state_name: StringName = ""

	if state != null:
		last_state_name = state.name
		state._state_exit()

	state = get_node(NodePath(new_state))
	state.state_machine = self
	state._state_enter(last_state_name)

	state_changed.emit(last_state_name, new_state)
