extends Node

var save_data: SaveData

func _ready() -> void:
	save_data = SaveData.new()

func load_data() -> bool:
	if ResourceLoader.exists(save_data.save_location):
		save_data = load(save_data.save_location)
		return true
	return false

func save() -> void:
	save_data.save_scene = get_tree().current_scene.scene_file_path
	var player = get_tree().current_scene.get_node("%Player25D")
	if player:
		save_data.player_pos = player.position
	ResourceSaver.save(save_data, save_data.save_location)

func save_keybinding(action: StringName, event: InputEvent) -> void:
	save_data.keybindings[action] = event

func get_keybinding(action: StringName) -> InputEvent:
	if save_data.keybindings.has(action):
		return save_data.keybindings[action]
	return null