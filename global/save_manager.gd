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
	if get_tree().current_scene.name == "MainTitle":
		return
	save_data.save_scene = get_tree().current_scene.name
	var player = get_tree().current_scene.get_node("%Player25D")
	if player:
		save_data.player_pos = player.position
		save_data.quests_list = Quests.list
	ResourceSaver.save(save_data, save_data.save_location)

func save_volume(volume: float) -> void:
	save_data.volume_slider = volume

func save_keybinding(action: StringName, event: InputEvent) -> void:
	save_data.keybindings[action] = event

func get_keybinding(action: StringName) -> InputEvent:
	if save_data.keybindings.has(action):
		return save_data.keybindings[action]
	return null