extends Control

@onready var resolution_button: OptionButton = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/Resolution/OptionButton
@onready var fullscreen_button: CheckBox = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/Fullscreen/CheckBox
@onready var keybindings_button: Button = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/KeybindingsButton
@onready var music_slider: HSlider = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/MusicSFX/HSlider
@onready var save_button: Button = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/SaveButton
@onready var return_button: Button = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/ReturnButton
@onready var close_button: Button = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/CloseButton
@onready var exit_button: Button = $Panel/MarginContainer/TabContainer/ItemList/VBoxContainer/ExitButton

@onready var keybindings_panel: Control = $KeybindingPanel

@export var resolutions: Dictionary = {
	"1152x648": Vector2(640, 360)
}

@export var main_menu_scene: String = "MainTitle"

@export var main_menu: bool

var default_resolution = "1280x720"
var music_bus: int

func _ready() -> void:
	music_bus = AudioServer.get_bus_index("Music")
	visible = false
	add_resolutions()
	find_and_set_current_window_size()
	set_to_fullscreen_state()
	on_h_slider_value_changed(music_slider.value)

	fullscreen_button.toggled.connect(on_fullscreen_pressed)
	resolution_button.item_selected.connect(on_resolution_item_selected)
	music_slider.value_changed.connect(on_h_slider_value_changed)
	keybindings_button.pressed.connect(on_keybindings_pressed)
	save_button.pressed.connect(on_save_pressed)
	return_button.pressed.connect(on_return_pressed)
	close_button.pressed.connect(on_close_pressed)
	exit_button.pressed.connect(on_exit_pressed)
	
	if main_menu:
		save_button.visible = false
		return_button.visible = false
		exit_button.visible = false

func add_resolutions() -> void:
	for res in resolutions:
		resolution_button.add_item(res)

func find_and_set_current_window_size() -> void:
	var current_window_size = str(get_window().size.x) + "x" + str(get_window().size.y)
	var index = resolutions.keys().find(current_window_size)

	if index >= 0:
		resolution_button.selected = index
	else:
		index = resolutions.keys().find(default_resolution)
		resolution_button.selected = index
		on_resolution_item_selected(index)

func on_resolution_item_selected(index) -> void:
	if index >= 0:
		var res = resolution_button.get_item_text(index)
		get_window().size = resolutions[res]

func open() -> void:
	visible = true
	# get_tree().paused = true

func close() -> void:
	on_close_pressed()

func set_to_fullscreen_state() -> void:
	on_fullscreen_pressed(fullscreen_button.button_pressed)

func on_keybindings_pressed() -> void:
	keybindings_panel.visible = true

func on_fullscreen_pressed(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func on_return_pressed() -> void:
	SceneManager.change_scene(main_menu_scene)

func on_save_pressed() -> void:
	SaveManager.save()

func on_close_pressed() -> void:
	visible = false
	keybindings_panel.visible = false
	# get_tree().paused = false

func on_exit_pressed() -> void:
	# get_tree().paused = false
	get_tree().quit()

func set_volume(bus_index: int, volume: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

func on_h_slider_value_changed(value: float) -> void:
	set_volume(music_bus, value)
