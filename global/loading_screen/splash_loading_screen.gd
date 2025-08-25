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
	"FirstSchool1": "res://overworld/cutscenes/first_steps/first_school_1.tscn",
	"FirstSchool2": "res://overworld/cutscenes/first_steps/first_school_2.tscn"
}

@export var music_dictionary: Dictionary[String, String] = {
	"Boss1": "res://global/audio/background_music/Boss1.wav",
	"Boss2": "res://global/audio/background_music/Boss2.wav",
	"FinalBossReal": "res://global/audio/background_music/FinalBossReal.wav",
	"SomewhereInIdaho": "res://global/audio/background_music/SomewhereInIdaho.wav",
	"SchoolDay": "res://global/audio/background_music/SchoolDay.wav"
}

const SECOND: float = 1000.0

var first_frame: bool = true
var total: float = 0.0

func _ready() -> void:
	$Snake.play("default")
	$Text.play("default")

func _process(delta: float) -> void:
	total += delta * SECOND
	if total < SECOND:
		return
	elif first_frame:
		call_deferred("start_loading_dictionary", scene_dictionary)
		call_deferred("start_loading_dictionary", music_dictionary)
		first_frame = false
		return
	else:
		total = 0

	if !get_dictionary_progress(scene_dictionary):
		return
	if !get_dictionary_progress(music_dictionary):
		return
	call_deferred("load_threaded")

func load_threaded() -> void:
	var temp_scene_dict: Dictionary[String, PackedScene] = {}
	for key in scene_dictionary:
		temp_scene_dict[key] = ResourceLoader.load_threaded_get(scene_dictionary[key])
	var temp_music_dict: Dictionary[String, AudioStreamWAV] = {}
	for key in music_dictionary:
		temp_music_dict[key] = ResourceLoader.load_threaded_get(music_dictionary[key])
	SceneManager.scene_dictionary = temp_scene_dict
	AudioManager.music_dictionary = temp_music_dict

	for key in AudioManager.music_dictionary:
		AudioManager.music_dictionary[key].loop_mode = AudioStreamWAV.LOOP_FORWARD
		AudioManager.music_dictionary[key].loop_end = int(AudioManager.music_dictionary[key].mix_rate * AudioManager.music_dictionary[key].get_length())

	SceneManager.change_scene(to_scene)

func start_loading_dictionary(dict: Dictionary) -> void:
	for key in dict:
		ResourceLoader.load_threaded_request(dict[key], "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)

func get_dictionary_progress(dict: Dictionary) -> bool:
	for key in dict:
		var status := ResourceLoader.load_threaded_get_status(dict[key])
		if status != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if status != ResourceLoader.THREAD_LOAD_LOADED:
				print("Error loading resource: ", key, " with error code ", status)
				get_tree().paused = true
				# get_tree().quit()
		else:
			return false
	return true
