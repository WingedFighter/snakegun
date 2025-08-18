extends CharacterBody2D

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_depleted.connect(die)

func die() -> void:
	print_debug("dude focken died")
	pass
