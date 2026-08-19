class_name Health
extends Node

@export var health: int = 100
@export var max_health: int = 100
@export var invincible: bool = false

var is_dead: bool = false

signal updated(health: int)
signal configured(health: int)
signal gained(amount: int, health: int)
signal max(health: int)
signal lost(amount: int, health: int)
signal died
signal invincibility_enabled
signal invincibility_disabled
signal invincibility_hit(amount: int)

func propagate() -> void:
	emit_signal("updated", health)
	
func configure(new_health: int = 100, new_max_health: int = 150, new_invincible: bool = false) -> void:
	health = new_health
	max_health = new_max_health
	invincible = new_invincible

	emit_signal("configured", health)
	propagate()

func lose_health(amount: int) -> void:
	if (health <= 0):
		return

	if (invincible):
		emit_signal("invincibility_hit", amount)
		return

	health -= amount
	emit_signal("lost", amount, health)

	if (health <= 0):
		health = 0
		is_dead = true
		emit_signal("died")
	propagate()

func gain_health(amount: int) -> void:
	if (health >= max_health):
		return

	health += amount
	emit_signal("gained", amount, health)

	if (health >= max_health):
		health = max_health
		emit_signal("max", health)
	propagate()

func set_invincible(value: bool) -> void:
	invincible = value

	if (invincible):
		emit_signal("invincibility_enabled")
	else:
		emit_signal("invincibility_disabled")