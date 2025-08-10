extends Area2D
class_name Interactable

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player25D:
		body.hud.last_interactable = self

func on_body_exited(body: Node2D) -> void:
	if body is Player25D && body.hud.last_interactable == self:
		body.hud.last_interactable = null