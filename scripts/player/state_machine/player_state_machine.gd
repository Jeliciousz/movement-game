class_name PlayerStateMachine extends Node


@export var states: Dictionary[StringName, PlayerState]

@export var initial_state: StringName

@export var player: Player


var active_state: PlayerState

var active_state_name: StringName


func transition(to_state: String) -> void:
	assert(states.has(to_state), "a state with name \"%s\" does not exist in state machine" % to_state)
	
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


func update(delta: float) -> void:
	if not active_state:
		return
	
	active_state.state_checks()
	
	active_state.update(delta)
