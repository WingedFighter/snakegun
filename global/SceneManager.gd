extends Node

var scene_history: Array[String] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	push_new_scene()

func push_new_scene() -> void:
	if get_tree().current_scene != null:
		if len(scene_history) == 0:
			scene_history.push_front(get_tree().current_scene.get_name())
		elif get_tree().current_scene.get_name() != scene_history[0]:
			scene_history.push_front(get_tree().current_scene.get_name())

func get_previous_scene() -> String:
	push_new_scene()
	if len(scene_history) > 1:
		return scene_history[1]
	return ""
