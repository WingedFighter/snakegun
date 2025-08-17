extends Node

var scene_dictionary: Dictionary[String, PackedScene] = {
	"MainTitle": preload("res://ui/main_title/main_title.tscn"),
	"OutsideTownMain": preload("res://overworld/maps/outside/town/main/outside_town_main.tscn"),
	"OutsideTownSchool": preload("res://overworld/maps/outside/town/school/outside_town_school.tscn"),
	"InsideHeroRoom": preload("res://overworld/maps/inside/inside_hero_room.tscn")
}

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

func get_current_scene() -> String:
	push_new_scene()
	if len(scene_history) > 0:
		return scene_history[0]
	return ""

func change_scene(scene: String) -> int:
	return get_tree().change_scene_to_packed(scene_dictionary[scene])