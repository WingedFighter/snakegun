extends Node2D

@export var maxHealth: float
var currentHealth: float

func _ready() -> void:
	currentHealth = maxHealth

func hurt(damage: float) -> void:
	currentHealth -= damage
	
func heal(health: float) -> void:
	hurt(-health)
