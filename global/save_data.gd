extends Resource
class_name SaveData

@export var save_scene: String
@export var player_pos: Vector2
@export var save_location: String
@export var keybindings: Dictionary[StringName, InputEvent]

func _init(p_scene: String = "", p_pos: Vector2 = Vector2.ZERO,
				  p_save: String = "user://save_0.tres",
				  p_keys: Dictionary[StringName, InputEvent] = {}) -> void:
	save_scene = p_scene
	player_pos = p_pos
	save_location = p_save
	keybindings = p_keys
