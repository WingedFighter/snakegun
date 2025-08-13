class_name HealthComponent
extends Node2D

@export var maxHealth: float = 100.0
var currentHealth: float

signal health_depleted
signal health_lost
signal health_increased

func _ready() -> void:
	currentHealth = maxHealth

func hurt(damage: float) -> void:
	if (damage < 0):
		health_lost.emit()
	if (damage > 0):
		health_increased.emit()
	currentHealth -= damage
	if (currentHealth <= 0):
		health_depleted.emit()
	
func heal(health: float) -> void:
	hurt(-health)
