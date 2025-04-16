extends Node


@export var player: Player


enum { NORMAL, NULL_CANCELING }


var nc_input_vector: Vector2 = Vector2.ZERO

var movement_mode = NULL_CANCELING:
	set(mode):
		nc_input_vector = Vector2.ZERO
		movement_mode = mode


func _physics_process(delta: float) -> void:
	match movement_mode:
		NORMAL:
			var vector = Input.get_vector("left", "right", "forward", "back")
			player.move_direction = player.basis * Vector3(vector.x, 0, vector.y)
		NULL_CANCELING:
			null_canceling_movement()
			player.move_direction = player.basis * Vector3(nc_input_vector.x, 0, nc_input_vector.y).normalized()


func null_canceling_movement() -> void:
	#	I didn't want to use Input.get_vector(...), because when opposing movement keys are pressed at the same time, it treats it as if the player hasn't pressed anything at all
	#
	#	What usually is happening when opposing movement keys are pressed at the same time, is that the player is switching between either key rapidly
	#	This happens a lot in fast-paced games
	#	But when opposing movement keys cancel each other out, it makes the player stand still in the small amount of time between pushing the new key, and releasing the old key
	#	This is the opposite of what the player wants: to keep moving
	#
	#	To fix this, I wrote it so that new inputs overwrite the previous ones, instead of canceling them out
	#	Then when the new input is released, it'll go back to the old input if it's still pressed, and only if it isn't, will it go to 0
	#
	#	This is called "Null-Canceling Movement", a concept I borrowed from a TF2 script, but I designed this code myself
	#
	#	-Jeliciousz
	
	if Input.is_action_just_pressed("back"):
		nc_input_vector.y = 1
	elif Input.is_action_just_released("back"):
		nc_input_vector.y = -float(Input.is_action_pressed("forward"))
	
	if Input.is_action_just_pressed("forward"):
		nc_input_vector.y = -1
	elif Input.is_action_just_released("forward"):
		nc_input_vector.y = float(Input.is_action_pressed("back"))
	
	if Input.is_action_just_pressed("left"):
		nc_input_vector.x = -1
	elif Input.is_action_just_released("left"):
		nc_input_vector.x = float(Input.is_action_pressed("right"))
	
	if Input.is_action_just_pressed("right"):
		nc_input_vector.x = 1
	elif Input.is_action_just_released("right"):
		nc_input_vector.x = -float(Input.is_action_pressed("left"))
