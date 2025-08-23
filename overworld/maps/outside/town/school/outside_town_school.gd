extends Node2D

@export var background_music: String = "SomewhereInIdaho"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(background_music)