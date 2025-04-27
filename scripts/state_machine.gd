class_name StateMachine
extends Node
## Handles updating and switching between [State]s.

## Emitted when the [StateMachine] changes state.
signal state_changed(last: StringName, current: StringName)

## The [State] that this [StateMachine] will start in.
@export var initial_state: State

## The dictionary of values shared between the states in a state machine.
var _shared_vars: Dictionary[StringName, Variant] = {}

## The currently active state.
@onready var _state: State = initial_state


func _ready() -> void:
	if _state == null:
		return

	_state.state_machine = self
	_state.shared_vars = _shared_vars
	_state._state_enter()


func _process(delta: float) -> void:
	if _state == null:
		return

	_state._state_preprocess(delta)

	_state._state_process(delta)


func _physics_process(delta: float) -> void:
	if _state == null:
		return

	_state._state_physics_preprocess(delta)

	_state._state_physics_process(delta)


func _input(event: InputEvent) -> void:
	if _state == null:
		return

	_state._state_input(event)


func _unhandled_input(event: InputEvent) -> void:
	if _state == null:
		return

	_state._state_unhandled_input(event)


## Returns the name of the current state.
func get_state_name() -> StringName:
	return _state.name


## Transition to a new state.
func change_state_to(state: StringName) -> void:
	if not has_node(NodePath(state)):
		printerr("The StateMachine does not have a child State with the name: '%s'" % state)
		return

	var last_state_name: StringName = ""

	if _state != null:
		last_state_name = _state.name
		_state._state_exit()

	_state = get_node(NodePath(state))
	_state.state_machine = self
	_state.shared_vars = _shared_vars
	_state._state_enter()

	state_changed.emit(last_state_name, _state.name)
