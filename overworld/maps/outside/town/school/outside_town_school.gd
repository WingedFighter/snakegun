extends Node2D

@export var background_music: String = "SomewhereInIdaho"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(background_music)
	if State.flags.has('second_steps') && State.flags['second_steps']:
		$Interactables/Transitions/FirstSchool1.condition = "second_steps"
		$Interactables/Transitions/FirstSchool1.to_scene = "SecondSchool1"
	elif State.flags.has('transformation'):
		$Interactables/Transitions/FirstSchool1.condition = "not_doable"
