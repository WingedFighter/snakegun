extends Node2D

var stopped: bool = false

var music_dictionary: Dictionary[String, AudioStream]
var sfx_dictionary: Dictionary[String, AudioStream]
var background_music: AudioStreamPlayer
var current_track: String

func _ready() -> void:
	background_music = AudioStreamPlayer.new()
	add_child(background_music)

	background_music.bus = "Music"

func is_ready() -> bool:
	if len(music_dictionary) > 0 and len(sfx_dictionary) > 0:
		return true
	return false

func play_music(song: String) -> void:
	if !is_ready():
		return
	if background_music && current_track != song:
		stopped = false
		current_track = song
		background_music.stream = music_dictionary[song]
		background_music.play()

func play_sfx(sound: String) -> void:
	if !is_ready():
		return
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sfx)
	sfx.bus = "SFX"
	sfx.stream = sfx_dictionary[sound]
	sfx.play()
	sfx.finished.connect(on_sfx_finished.bind(sfx))

func stop_music() -> void:
	if !is_ready():
		return
	if background_music:
		stopped = true
		background_music.stop()

func get_current_track_name() -> String:
	return current_track

func on_sfx_finished(sfx: AudioStreamPlayer) -> void:
	sfx.queue_free()
