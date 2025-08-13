extends Node2D

@export var damage: float = 1
@onready var bullet = preload("res://platformer/components/bullet.tscn")

# Fire is called with velocity from whatever actor's intent, player or AI controllers
func fire(velocity: Vector2, d: float) -> void:
	var fired_bullet = bullet.instance()
	if (d != null):
		fired_bullet.damage = d
	else:
		fired_bullet.damage = damage
	fired_bullet.global_position = global_position
	fired_bullet.v = velocity
