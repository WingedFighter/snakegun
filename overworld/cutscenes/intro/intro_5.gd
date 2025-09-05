extends Node2D

@onready var video: VideoStreamPlayer = $VideoStreamPlayer

@export var change_scene: String = "Intro6"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !video.is_playing():
		SceneManager.change_scene(change_scene)
