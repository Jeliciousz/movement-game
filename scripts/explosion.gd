extends Area3D


@onready var collision_shape = $CollisionShape


func _process(delta: float) -> void:
	DebugDraw3D.draw_sphere(global_position, collision_shape.shape.radius, Color.RED)


func explode(max_power: float, min_power) -> void:
	for body in get_overlapping_bodies():
		var explosion_radius = collision_shape.shape.radius
		
		if body is RigidBody3D:
			var other_position = body.global_position + body.center_of_mass
			
			var distance = global_position.distance_to(other_position)
			
			var weight = ease(clampf(distance / explosion_radius, 0, 1), 4)
			
			var power = lerpf(max_power, min_power, weight)
			
			var direction = global_position.direction_to(other_position)
			
			body.linear_velocity += direction * power
		elif body is Player:
			var collision_shape = body.get_node("CollisionShape")
			
			var player_height = collision_shape.shape.height
			
			var other_position = body.global_position
			other_position.y += player_height / 2
			
			var distance = global_position.distance_to(other_position)
			
			print_debug(distance)
			
			var weight = ease(clampf(distance / explosion_radius, 0, 1), 4)
			
			print_debug(weight)
			
			var power = lerpf(max_power, min_power, weight)
			
			var direction = global_position.direction_to(other_position)
			
			body.velocity += direction * power
	
	queue_free()
