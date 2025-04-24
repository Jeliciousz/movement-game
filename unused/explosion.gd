extends Area3D


## The base amount of damage that the explosion will deal.
@export_range(0, 100, 1, "or_greater") var base_damage: float = 90
## How much the damage is reduced by proportionally to the distance to the explosion (% of base damage per meter).
@export var splash_reduction: float = 0.17


@onready var collision_shape = $CollisionShape
@onready var explosion_audio = $ExplosionAudio


var exploded: bool = false


func _physics_process(delta: float) -> void:
	if not exploded:
		explode()


func explode() -> void:
	for body in get_overlapping_bodies():
		var explosion_radius = collision_shape.shape.radius
		
		if body is RigidBody3D:
			var other_position = body.global_position + body.center_of_mass
			
			var distance = global_position.distance_to(other_position)
			
			var damage = base_damage * (1 - minf(splash_reduction * distance, 1))
			
			var direction = global_position.direction_to(other_position)
			
			body.linear_velocity += direction * damage * 0.16 * 1.35
		elif body is Player:
			var collision_shape = body.get_node("CollisionShape")
			
			var player_height = collision_shape.shape.height
			
			var other_position = body.global_position
			other_position.y += player_height / 2
			
			var distance = global_position.distance_to(other_position)
			
			var damage = base_damage * (1 - minf(splash_reduction * distance, 1))
			
			var direction = global_position.direction_to(other_position)
			
			var knockback = direction * damage * 0.16
			
			if not body.is_on_floor(): #or body.state_machine.current_state.name == &"PlayerWallrunning"
				knockback *= 1.35
			
			body.velocity += knockback
			
			body.state_machine.on_child_transition(&"PlayerAirborne")
	
	explosion_audio.play()
	
	exploded = true
