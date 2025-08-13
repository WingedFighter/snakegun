extends Node2D

@export_file("*.tscn") var transition_scene: String

@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player25D:
		get_tree().change_scene_to_file(transition_scene)
