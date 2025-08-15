extends Interactable
class_name Transition

@export_file("*.tscn") var transition_scene: String

@export var immediate: bool = false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	if immediate:
		body_entered.connect(immediate_transition)

func immediate_transition(body: Node2D) -> void:
	if body is Player25D:
		body.hud.last_interactable = self
		call_deferred("change_scene", transition_scene)

func interact() -> void:
	call_deferred("change_scene", transition_scene)

func change_scene(target_scene: String) -> void:
	get_tree().change_scene_to_file(target_scene)

func on_body_entered(body: Node2D) -> void:
	if body is Player25D:
		body.hud.last_interactable = self

func on_body_exited(body: Node2D) -> void:
	if body is Player25D && body.hud.last_interactable == self:
		body.hud.last_interactable = null