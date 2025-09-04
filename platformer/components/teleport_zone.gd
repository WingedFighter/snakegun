extends Area2D

@onready var teleport_point: Node2D = $TeleportPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	body.global_position = teleport_point.global_position
