class_name HitboxComponent
extends Area3D
## A hitbox that hits hurtboxes.

## Should the hitbox kill entities immediately.
@export var kills: bool = false
## How much damage the hitbox deals.
@export var damage: float = 1.0
## Should the hitbox only hit once when it overlaps a hurtbox.
@export var hit_once: bool = true
## The interval in milliseconds between damage ticks.
@export var damage_interval: int = 500
