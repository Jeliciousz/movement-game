class_name HurtboxComponent
extends Area3D
## The hurtbox of an entity.

## Emitted when the hurtbox is hit.
signal hit(damage_taken: int)

## The health component of the same entity.
@export var health_component: HealthComponent

var hitboxes: Array[HitboxComponent] = []
var last_hit_timestamps: Array[float] = []


func _physics_process(_delta: float) -> void:
	if health_component.health <= 0:
		return

	if hitboxes.is_empty():
		return

	for index in hitboxes.size():
		var hitbox: HitboxComponent = hitboxes[index]

		if health_component.invulnerable and not hitbox.ignore_invulnerability:
			continue

		var time_delta: float = Global.time - last_hit_timestamps[index]

		if time_delta < hitbox.damage_interval:
			continue

		var damage_ticks: int = floor(time_delta / hitbox.damage_interval)
		var damage_dealt: int = hitbox.damage * damage_ticks

		last_hit_timestamps[index] += hitbox.damage_interval * damage_ticks

		health_component.damage(damage_dealt, hitbox.ignore_invulnerability)
		hit.emit(damage_dealt)

		if health_component.health <= 0:
			hitboxes.clear()
			last_hit_timestamps.clear()
			return


func _on_area_entered(area: Area3D) -> void:
	if health_component.health <= 0:
		return

	if not area is HitboxComponent:
		return

	var hitbox: HitboxComponent = area

	if hitbox.kills:
		if not health_component.invulnerable or hitbox.ignore_invulnerability:
			var damage_dealt: int = health_component.health
			health_component.kill(hitbox.ignore_invulnerability)
			hit.emit(damage_dealt)
	elif hitbox.hit_once:
		if not health_component.invulnerable or hitbox.ignore_invulnerability:
			var damage_dealt: int = mini(hitbox.damage, health_component.health)
			health_component.damage(hitbox.damage, hitbox.ignore_invulnerability)
			hit.emit(damage_dealt)
	else:
		if not health_component.invulnerable or hitbox.ignore_invulnerability:
			var damage_dealt: int = mini(hitbox.damage, health_component.health)
			health_component.damage(hitbox.damage, hitbox.ignore_invulnerability)
			hit.emit(damage_dealt)

		hitboxes.push_back(hitbox)
		last_hit_timestamps.push_back(Global.time)


func _on_area_exited(area: Area3D) -> void:
	if health_component.health <= 0:
		return

	if not area is HitboxComponent:
		return

	var index: int = hitboxes.find(area)

	if index == -1:
		return

	hitboxes.remove_at(index)
	last_hit_timestamps.remove_at(index)
