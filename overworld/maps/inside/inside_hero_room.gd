extends Node2D

@export var background_music: String = "SomewhereInIdaho"

@onready var first_time: Control = $FirstTimePlaying

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(background_music)

	if SceneManager.get_previous_scene().contains("Intro"):
		print("here")
		first_time.visible = true