class_name ShootComponent
extends Node2D

@export var damage: float = 1
@onready var bullet = preload("res://platformer/components/bullet.tscn")
var root: Window

func _ready():
	root = get_tree().root

# Fire is called with velocity from whatever actor's intent, player or AI controllers
func fire(velocity: Vector2, d: float) -> void:
	var fired_bullet = bullet.instantiate()
	if (d != null):
		fired_bullet.damage = d
	else:
		fired_bullet.damage = damage
	fired_bullet.global_position = global_position
	fired_bullet.v = velocity
	root.add_child(fired_bullet)
