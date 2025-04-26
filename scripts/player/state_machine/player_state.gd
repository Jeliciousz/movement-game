class_name PlayerState extends Resource
## A state the [PlayerStateMachine] can transition to and update on.


## The function a state can call to transition to a new state.
var transition_func: Callable

## The player.
var player: Player


## Called when the state is transitioned to.
func enter() -> void:
	pass


## Called when the state is transitioned from.
func exit() -> void:
	pass


## Called before updates.
func state_checks() -> void:
	pass


## Called on physics process.
func physics_update(_delta: float) -> void:
	pass


## Called after updates.
func post_update_checks() -> void:
	pass


## Called on process.
func update(_delta: float) -> void:
	pass
