class_name State
extends Node
## A state used by a [StateMachine].
##
## Can be entered, exited, and updated per physics and idle frame.

## Reference to the parent [StateMachine].
var state_machine: StateMachine

## The dictionary of values shared between the states in a state machine.
var shared_vars: Dictionary[StringName, Variant]


## Called when the state is transitioned to.
func _state_enter() -> void:
	pass


## Called on process.
func _state_process(_delta: float) -> void:
	pass


## Called on physics process.
func _state_physics_process(_delta: float) -> void:
	pass


## Called on input.
func _state_input(_event: InputEvent) -> void:
	pass


## Called on unhandled input.
func _state_unhandled_input(_event: InputEvent) -> void:
	pass


## Called when the state is transitioned from.
func _state_exit() -> void:
	pass
