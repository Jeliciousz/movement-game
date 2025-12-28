extends Node
## The Global Autoload.

const MAX_INT: int = 9223372036854775807
const MIN_INT: int = -9223372036854775808

var time: float = 0.0
var game_manager: GameManager


func _init() -> void:
	Input.use_accumulated_input = false


func _physics_process(delta: float) -> void:
	time += delta


func reset_time() -> void:
	time = 0.0
