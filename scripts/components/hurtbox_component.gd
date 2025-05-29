class_name HurtboxComponent
extends Area3D
## The hurtbox of an entity.

## Emitted when the hurtbox is hit.
signal hit(damage_taken: float, new_health: float)

## The health component of the same entity.
@export var health_component: HealthComponent

var hitboxes: Array[HitboxComponent] = []
var last_hit_timestamps: Array[int] = []


func _physics_process(_delta: float) -> void:
	if not health_component.alive:
		return

	if hitboxes.is_empty():
		return

	for index in hitboxes.size():
		var hitbox: HitboxComponent = hitboxes[index]
		var time_delta: int = Time.get_ticks_msec() - last_hit_timestamps[index]

		if time_delta < hitbox.damage_interval:
			continue

		var damage_ticks: int = time_delta / hitbox.damage_interval
		var damage_dealt: float = hitbox.damage * damage_ticks

		last_hit_timestamps[index] += hitbox.damage_interval * damage_ticks

		health_component.damage(damage_dealt)
		hit.emit(damage_dealt, health_component.current_health)

		if not health_component.alive:
			hitboxes.clear()
			last_hit_timestamps.clear()
			return


func _on_area_entered(area: Area3D) -> void:
	if not health_component.alive:
		return

	if not area is HitboxComponent:
		return

	var hitbox: HitboxComponent = area

	if hitbox.kills:
		var damage_dealt: float = health_component.current_health
		health_component.kill()
		hit.emit(damage_dealt, 0.0)
	elif hitbox.hit_once:
		health_component.damage(hitbox.damage)
		hit.emit(hitbox.damage, health_component.current_health)
	else:
		health_component.damage(hitbox.damage)
		hit.emit(hitbox.damage, health_component.current_health)

		hitboxes.push_back(hitbox)
		last_hit_timestamps.push_back(Time.get_ticks_msec())


func _on_area_exited(area: Area3D) -> void:
	if not health_component.alive:
		return

	if not area is HitboxComponent:
		return

	if not hitboxes.has(area):
		return

	var index: int = hitboxes.find(area)
	hitboxes.remove_at(index)
	last_hit_timestamps.remove_at(index)
