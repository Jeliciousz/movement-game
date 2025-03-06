class_name Player extends CharacterBody3D


@export var top_speed: float = 12.0
@export var acceleration: float = 1.0


func _physics_process(delta: float) -> void:
	var input_axis: Vector2 = Input.get_vector("left", "right", "back", "forward")
	var move_vector: Vector3 = transform.basis * Vector3(input_axis.x, 0.0, -input_axis.y)
	
	
	
	move_and_slide()
