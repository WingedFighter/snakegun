class_name ShootComponent
extends Node2D

@export var damage: float = 1
@export var accuracy: float = 0
@onready var bullet = preload("res://platformer/components/bullet.tscn")
var root: Window
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal shot

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
	if accuracy != 0:
		fired_bullet.v.y = rng.randf_range(-accuracy, accuracy)
	root.add_child(fired_bullet)
	shot.emit()
