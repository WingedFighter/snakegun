extends Control
class_name QuestList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SceneManager.get_previous_scene().contains("Intro"):
		visible = false