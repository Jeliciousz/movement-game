extends Node3D


var rocket = preload("res://scenes/rocket.tscn")

@onready var player = $"../../../../.."
@onready var fire_sound = $FireSound

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("primary fire"):
		var projectile = rocket.instantiate()
		projectile.position = player.global_position
		projectile.position.y += 1.4
		projectile.position += player.get_camera_look_direction() * 1
		projectile.velocity = player.get_camera_look_direction() * 29
		get_tree().root.add_child(projectile)
		fire_sound.play()
