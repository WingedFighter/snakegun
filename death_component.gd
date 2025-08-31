extends Node2D

@export var to_delete: Node2D
@export var health_component: HealthComponent
@onready var explosion = preload("res://platformer/components/explosion.tscn")
var drop_pickup: bool = true
@onready var pickup = preload("res://platformer/components/pickup.tscn")

func _ready() -> void:
	health_component.health_depleted.connect(on_death)

func on_death() -> void:
	var ex = explosion.instantiate()
	ex.position = to_delete.position
	if drop_pickup:
		var pick = pickup.instantiate()
		pick.position = to_delete.position
		call_deferred('add', pick)
	call_deferred('add', ex)
	to_delete.queue_free()

func add(node) -> void:
	get_tree().root.add_child(node)
