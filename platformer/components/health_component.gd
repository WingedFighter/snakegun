class_name HealthComponent
extends Node2D

@export var max_health: float = 100.0
var current_health: float

signal health_depleted
signal health_lost
signal health_increased

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

func heal(health: float) -> void:
	hurt(-health)
