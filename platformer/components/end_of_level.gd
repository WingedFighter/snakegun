extends Area2D

signal end_of_level()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is PlayerMegaman:
		end_of_level.emit()
