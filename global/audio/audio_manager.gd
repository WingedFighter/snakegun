extends Node2D

var audio_manager_scene: PackedScene = preload("res://global/audio/audio_manager.tscn")

var music_dictionary: Dictionary[String, AudioStream]
var background_music: AudioStreamPlayer
var current_track: String

func _ready() -> void:
	var audio_scene = audio_manager_scene.instantiate()
	add_child(audio_scene)

	background_music = audio_scene.get_node("BackgroundMusic")

func _process(_delta: float) -> void:
	if background_music && !background_music.playing:
		background_music.play(0.0)

func play_music(song: String) -> void:
	if background_music:
		current_track = song
		background_music.stream = music_dictionary[song]
		background_music.play()

func get_current_track_name() -> String:
	return current_track
