class_name HealthComponent
extends Node
## The health of an entity.

signal max_health_changed(change: int)
signal health_changed(change: int)
signal healed(amount: int)
signal damaged(amount: int)
signal died(damage_taken: int)
signal revived()

@export var max_health: int = 3 : set = set_max_health
@export var invulnerable: bool = false : set = set_invulnerable

var invulnerability_timer: Timer = null

@onready var health: int = max_health


func set_max_health(value: int) -> void:
	var clamped_value: int = maxi(value, 1)

	if clamped_value == max_health:
		return

	var change: int = clamped_value - max_health
	max_health = clamped_value

	if health > max_health:
		health = max_health

	max_health_changed.emit(change)


func set_invulnerable(value: bool) -> void:
	invulnerable = value


func grant_temporary_invulnerability(seconds: float) -> void:
	if invulnerability_timer == null:
		invulnerability_timer = Timer.new()
		invulnerability_timer.one_shot = true
		invulnerability_timer.timeout.connect(set_invulnerable.bind(false))
		add_child(invulnerability_timer)

	invulnerable = true
	invulnerability_timer.start(seconds)


func damage(amount: int, ignore_invulnerability: bool) -> void:
	if invulnerable and not ignore_invulnerability:
		return

	if health <= 0:
		return

	if amount <= 0:
		return

	var clamped_damage: int = mini(amount, health)

	health -= clamped_damage
	health_changed.emit(-clamped_damage)

	if health == 0:
		died.emit(clamped_damage)
	else:
		damaged.emit(clamped_damage)


func heal(amount: int) -> void:
	if health == max_health:
		return

	if amount <= 0:
		return

	var clamped_amount: int = mini(amount, max_health - health)

	health += clamped_amount
	health_changed.emit(clamped_amount)

	if clamped_amount == health:
		revived.emit(clamped_amount)
	else:
		healed.emit(clamped_amount)


func kill(ignore_invulnerability: bool) -> void:
	if invulnerable and not ignore_invulnerability:
		return

	var damage_taken: int = health
	health = 0

	if damage_taken != 0:
		health_changed.emit(-damage_taken)
		died.emit(damage_taken)


func revive() -> void:
	if health > 0:
		return

	health = max_health

	health_changed.emit(max_health)
	revived.emit()
