extends Control

@export_file("*.tscn") var new_game_scene: String
@export_file("*.tscn") var continue_game_scene: String

@onready var new_game_button: Button = $NewGameButton
@onready var continue_button: Button = $ContinueButton
@onready var settings_button: Button = $SettingsButton
@onready var quit_button: Button = $QuitButton

func _physics_process(_delta: float) -> void:
	new_game_button.pressed.connect(new_game)
	continue_button.pressed.connect(continue_game)
	settings_button.pressed.connect(settings)
	quit_button.pressed.connect(quit_game)

	# Unpause if paused
	get_tree().paused = false
	# Defaults to overworld, so disable physics
	set_physics_process(false)

func new_game() -> void:
	get_tree().change_scene_to_file(new_game_scene)

func continue_game() -> void:
	get_tree().change_scene_to_file(continue_game_scene)

func settings() -> void:
	pass

func quit_game() -> void:
	get_tree().quit()
