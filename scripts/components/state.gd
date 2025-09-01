class_name State
extends Node
## A state used by a [StateMachine].
##
## Can be entered, exited, and updated per physics and idle frame.

## Reference to the parent [StateMachine].
var state_machine: StateMachine


## Called when the [StateMachine] changes to this state.
func _state_enter() -> void:
	pass


## Called when the [StateMachine] changes from this state.
func _state_exit() -> void:
	pass


## Called during [method StateMachine._process] before [method _state_process]. Use this to change the state based on user input. [method _state_process] will then be called on the new state.
func _state_preprocess(_delta: float) -> void:
	pass


## Called during [method StateMachine._process].
func _state_process(_delta: float) -> void:
	pass


## Called during [method StateMachine._physics_process] before [method _state_physics_process]. Use this to change the state based on user input. [method _state_physics_process] will then be called on the new state.
func _state_physics_preprocess(_delta: float) -> void:
	pass


## Called during [method StateMachine._physics_process].
func _state_physics_process(_delta: float) -> void:
	pass


## Called during [method StateMachine._input].
func _state_input(_event: InputEvent) -> void:
	pass


## Called during [method StateMachine._unhandled_input].
func _state_unhandled_input(_event: InputEvent) -> void:
	pass
