extends Node2D

var stopped: bool = false

var music_dictionary: Dictionary[String, AudioStreamWAV]
var background_music: AudioStreamPlayer
var current_track: String

func _ready() -> void:
	background_music = AudioStreamPlayer.new()
	add_child(background_music)

	background_music.bus = "Music"

func play_music(song: String) -> void:
	if background_music && current_track != song:
		stopped = false
		current_track = song
		background_music.stream = music_dictionary[song]
		background_music.play()

func stop_music() -> void:
	if background_music:
		stopped = true
		background_music.stop()

func get_current_track_name() -> String:
	return current_track
