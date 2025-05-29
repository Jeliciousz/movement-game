class_name HealthComponent
extends Node
## Represents the health of an entity.

## Emitted when the entity is damaged.
signal damaged(damage_taken: float, new_health: float)
## Emitted when the entity is healed.
signal healed(health_gained: float, new_health: float)
## Emitted when the entity dies.
signal died(damage_taken: float)

## The maximum health this entity has.
@export var max_health: float = 3.0

## The current health of the entity.
@onready var current_health: float = max_health


## Damage the health component.
##
## Returns whether the health component died from the damage dealt.
func damage(amount: float) -> bool:
	# If the damage is enough or more than enough to kill the entity, call kill().
	if amount >= current_health:
		kill()
		return true

	# Otherwise, emit damaged.
	current_health -= amount
	damaged.emit(amount, current_health)
	return false


## Heal the health component.
func heal(amount: float, ignore_max_health: bool) -> void:
	if not ignore_max_health and current_health + amount >= max_health:
		var health_gained: float = max_health - current_health
		current_health = max_health
		healed.emit(health_gained, current_health)
		return

	current_health += amount
	healed.emit(amount, current_health)


## Kill the health component.
func kill() -> void:
	var damage_taken: float = current_health

	current_health = 0.0
	died.emit(damage_taken)
