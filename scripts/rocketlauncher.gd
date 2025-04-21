extends Node3D


@export var fire_interval: int = 800


@onready var raycast: RayCast3D = $"../RayCast"
@onready var fire_sound: AudioStreamPlayer3D = $FireSound


var rocket = preload("res://scenes/rocket.tscn")

var last_fired_timestamp: int = 0


func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - last_fired_timestamp > fire_interval and Input.is_action_pressed("primary fire"):
		var projectile: StaticBody3D = rocket.instantiate()
		projectile.launch_speed = 18
		
		projectile.position = raycast.global_position + raycast.global_basis * Vector3(0, -0.3, 0)
		projectile.basis = raycast.global_basis
		
		if projectile.position.is_equal_approx(raycast.global_position):
			get_tree().root.add_child(projectile)
			return
		
		raycast.force_raycast_update()
		
		if not raycast.is_colliding():
			get_tree().root.add_child(projectile)
			return
		
		projectile.look_at_from_position(projectile.position, raycast.get_collision_point())
		
		get_tree().root.add_child(projectile)
		
		last_fired_timestamp = Time.get_ticks_msec()
		fire_sound.play()
