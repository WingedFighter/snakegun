extends Node2D

@export var background_music: String = "SomewhereInIdaho"

@onready var first_time: Control = $FirstTimePlaying

var starting_quests: Dictionary[String, String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(background_music)

	if SceneManager.get_previous_scene().contains("Intro"):
		Quests.list = [starting_quests]
		first_time.visible = true
		Quests.add_quest({"name": "First Steps", "contents": "Go to school"})
		State.flags['first_steps'] = true
	
	if State.flags.has("transformation"):
		if Quests.has_quest("Night Night"):
			Quests.complete_quest("Night Night")
			Quests.add_quest({"name": "Second Steps", "contents": "Go to school"})
			State.flags['second_steps'] = true
	
	if State.flags.has("explosion"):
		if Quests.has_quest("Night Night 2: Electric Boogaloo"):
			Quests.complete_quest("Night Night 2: Electric Boogaloo")
			Quests.add_quest({"name": "Third Steps", "contents": "Go to school"})
			State.flags['third_steps'] = true