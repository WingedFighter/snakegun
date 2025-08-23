extends Control

@export var new_game_scene: String = "Intro0"
@export var continue_game_scene: String = "InsideHereRoom"

@onready var new_game_button: TextureButton = $NewGameButton
@onready var continue_button: TextureButton = $ContinueButton
@onready var settings_button: TextureButton = $SettingsButton
@onready var quit_button: TextureButton = $QuitButton
@onready var escape_menu: Control = $EscapeMenu

func _ready() -> void:
	AudioManager.play_music("FinalBossReal")

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
	SceneManager.change_scene(new_game_scene)

func continue_game() -> void:
	if SaveManager.load_data():
		SceneManager.change_scene(SaveManager.save_data.save_scene)

func settings() -> void:
	escape_menu.open()

func quit_game() -> void:
	get_tree().quit()
