extends Node


@export var player: Player


var input_axis: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	#	This handles the movement inputs
	#
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
	#	The vector is normalized and transformed by the player direction in the process step
	#
	#	-Jeliciousz
	
	if Input.is_action_just_pressed("back"):
		input_axis.y = 1
	elif Input.is_action_just_released("back"):
		input_axis.y = -float(Input.is_action_pressed("forward"))
	
	if Input.is_action_just_pressed("forward"):
		input_axis.y = -1
	elif Input.is_action_just_released("forward"):
		input_axis.y = float(Input.is_action_pressed("back"))
	
	if Input.is_action_just_pressed("left"):
		input_axis.x = -1
	elif Input.is_action_just_released("left"):
		input_axis.x = float(Input.is_action_pressed("right"))
	
	if Input.is_action_just_pressed("right"):
		input_axis.x = 1
	elif Input.is_action_just_released("right"):
		input_axis.x = -float(Input.is_action_pressed("left"))
	
	player.move_direction = (player.basis * Vector3(input_axis.x, 0, input_axis.y)).normalized()
