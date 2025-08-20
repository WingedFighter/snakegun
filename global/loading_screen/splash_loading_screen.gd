extends CanvasLayer

@export var to_scene: String = "MainTitle"

@export var scene_dictionary: Dictionary[String, String] = {
	"MainTitle": "res://ui/main_title/main_title.tscn",
	"OutsideTownMain": "res://overworld/maps/outside/town/main/outside_town_main.tscn",
	"OutsideTownSchool": "res://overworld/maps/outside/town/school/outside_town_school.tscn",
	"InsideHeroRoom": "res://overworld/maps/inside/inside_hero_room.tscn",
	"Intro0": "res://overworld/cutscenes/intro/intro_0.tscn",
	"Intro1": "res://overworld/cutscenes/intro/intro_1.tscn",
	"Intro2": "res://overworld/cutscenes/intro/intro_2.tscn",
	"Intro3": "res://overworld/cutscenes/intro/intro_3.tscn",
	"Intro4": "res://overworld/cutscenes/intro/intro_4.tscn",
	"Intro5": "res://overworld/cutscenes/intro/intro_5.tscn",
	"Intro6": "res://overworld/cutscenes/intro/intro_6.tscn",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in scene_dictionary:
		ResourceLoader.load_threaded_request(scene_dictionary[key], "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)

func _process(_delta: float) -> void:
	for key in scene_dictionary:
		var status := ResourceLoader.load_threaded_get_status(scene_dictionary[key])
		if status != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if status != ResourceLoader.THREAD_LOAD_LOADED:
				print("Error loading resource: ", key, " with error code ", status)
		else:
			return
	var final_scene_dictionary: Dictionary[String, PackedScene] = {}
	for key in scene_dictionary:
		final_scene_dictionary[key] = ResourceLoader.load_threaded_get(scene_dictionary[key])
	SceneManager.scene_dictionary = final_scene_dictionary
	SceneManager.change_scene(to_scene)
