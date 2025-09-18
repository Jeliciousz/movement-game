class_name HealthComponent
extends Node
## The health of an entity.

## Emitted when the entity is damaged.
signal damaged(damage_taken: float, new_health: float)

## Emitted when the entity is healed.
signal healed(health_gained: float, new_health: float)

## Emitted when the entity dies.
signal died(damage_taken: float)

## Emitted when the entity is revived.
signal revived(health_gained: float)

## The maximum health this entity has.
@export var maximum_health: float = 3.0

## Whether the health component is alive.
var alive: bool = true

## The current health of the entity.
@onready var current_health: float = maximum_health


## Damage the health component.
##
## Does nothing if [param amount] <= 0 or the health component isn't [member alive].
func damage(amount: float) -> void:
	if amount <= 0.0:
		return

	if not alive:
		return

	# If the damage is enough or more than enough to kill the entity, call kill().
	if amount >= current_health:
		kill()
		return

	# Otherwise, emit damaged.
	current_health -= amount
	damaged.emit(amount, current_health)


## Heal the health component to the [member maximum_health].
##
## Does nothing if [param amount] <= 0 or [member current_health] == [member maximum_health]
func heal(amount: float) -> void:
	heal_to(amount, maximum_health)


## Heal the health component to a unique maximum health.
##
## Does nothing if [param amount] <= 0 or the health component isn't [member alive].
func heal_to(amount: float, max_health: float) -> void:
	if amount <= 0.0:
		return

	if not alive:
		revive(amount if amount < max_health else max_health)
		return

	if current_health == max_health:
		return

	if current_health + amount >= max_health:
		var health_gained: float = max_health - current_health
		current_health = max_health
		healed.emit(health_gained, current_health)
		return

	current_health += amount
	healed.emit(amount, current_health)


## Kill the health component.
func kill() -> void:
	if not alive:
		return

	alive = false

	var damage_taken: float = current_health
	current_health = 0.0
	died.emit(damage_taken)


## Revive the health component with a certain amount of health.
##
## Does nothing if the health component is alive.
func revive(revive_health: float) -> void:
	if alive:
		return

	alive = true

	current_health = revive_health
	revived.emit(current_health)
