extends Area2D

@export var first_parallax: Node2D
@export var second_parallax: Node2D
@export var physics_wall: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(trigger_parallax)

func trigger_parallax(_body: Node2D) -> void:
	first_parallax.visible = false
	second_parallax.visible = true
	physics_wall.set_deferred("disabled", false)
