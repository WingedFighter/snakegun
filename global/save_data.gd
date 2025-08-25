extends Resource
class_name SaveData

@export var save_scene: String
@export var player_pos: Vector2
@export var save_location: String
@export var volume_slider: float
@export var quests_list: Array[Dictionary]
@export var state_flags: Dictionary[String, bool]
@export var keybindings: Dictionary[StringName, InputEvent]

func _init(
    p_scene: String = "",
    p_pos: Vector2 = Vector2.ZERO,
    p_save: String = "user://save_0.tres",
    p_volume: float = 0.6,
	p_quests: Array[Dictionary] = [],
	p_flags: Dictionary[String, bool] = {},
    p_keys: Dictionary[StringName, InputEvent] = {}
) -> void:
	save_scene = p_scene
	player_pos = p_pos
	save_location = p_save
	volume_slider = p_volume
	quests_list = p_quests
	state_flags = p_flags
	keybindings = p_keys
