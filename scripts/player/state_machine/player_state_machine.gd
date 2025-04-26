class_name PlayerStateMachine extends Node
## Handles the active [PlayerState] of the [Player], transitioning between states, and updating the [Player] with the active state.


## The states the state machine process and transitions between.
@export var states: Dictionary[StringName, PlayerState]

## The state that the state machine will start in.
@export var initial_state: StringName

## The Player.
@export var player: Player


## The currently active state.
var active_state: PlayerState

## The name of the currently active state.
var active_state_name: StringName


## Transition to a new state.
func transition(to_state: String) -> void:
	if not states.has(to_state):
		printerr("The PlayerStateMachine does not have a state with the name: '%s'!" % to_state)
		return

	if active_state:
		active_state.exit()

	active_state = states[to_state]
	active_state_name = to_state

	active_state.transition_func = transition
	active_state.player = player

	active_state.enter()


func _ready() -> void:
	if initial_state:
		active_state = states[initial_state]
		active_state_name = initial_state

		active_state.transition_func = transition
		active_state.player = player

		active_state.enter()


## Called before updates.
func state_checks() -> void:
	if not active_state:
		return

	active_state.state_checks()


## Called on physics process.
func physics_update(delta: float) -> void:
	if not active_state:
		return

	active_state.physics_update(delta)


## Called after updates.
func post_update_checks() -> void:
	if not active_state:
		return

	active_state.post_update_checks()


## Called on process.
func update(delta: float) -> void:
	if not active_state:
		return

	active_state.update(delta)
