class_name HealthComponent
extends Node2D

@export var max_health: float = 100.0
var current_health: float

signal health_depleted
signal health_lost
signal health_increased
signal health_changed(old, new)

func _ready() -> void:
	current_health = max_health

func hurt(damage: float) -> void:
	current_health -= damage

	if (damage > 0):
		health_lost.emit()
	if (damage < 0):
		health_increased.emit()
	if (current_health <= 0):
		health_depleted.emit()
	health_changed.emit(current_health, current_health + damage)

func heal(health: float) -> void:
	hurt(-health)
