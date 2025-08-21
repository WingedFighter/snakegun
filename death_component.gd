extends Node2D

@export var to_delete: Node2D
@export var health_component: HealthComponent
@onready var explosion = preload("res://platformer/components/explosion.tscn")

func _ready() -> void:
	health_component.health_depleted.connect(on_death)

func on_death() -> void:
	var ex = explosion.instantiate()
	ex.position = to_delete.position
	get_tree().root.add_child(ex)
	to_delete.queue_free()
