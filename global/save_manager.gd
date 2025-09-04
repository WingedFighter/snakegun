extends Node

var save_data: SaveData

func _ready() -> void:
	if ResourceLoader.exists(save_data.save_location):
		save_data = ResourceLoader.load(save_data.save_location, "", ResourceLoader.CacheMode.CACHE_MODE_IGNORE)
		State.flags.merge(save_data.state_flags)
	else:
		save_data = SaveData.new()

func save() -> void:
	if get_tree().current_scene.has_node("%Player25D"):
		save_data.save_scene = get_tree().current_scene.name
		var player = get_tree().current_scene.get_node("%Player25D")
		if player:
			save_data.player_pos = player.position
	save_data.quests_list = Quests.list
	save_data.state_flags = State.flags
	ResourceSaver.save(save_data, save_data.save_location)

func save_volume(volume: float) -> void:
	save_data.volume_slider = volume
	ResourceSaver.save(save_data, save_data.save_location)

func save_sfx_volume(volume: float) -> void:
	save_data.sfx_volume_slider = volume
	ResourceSaver.save(save_data, save_data.save_location)

func save_keybinding(action: StringName, event: InputEvent) -> void:
	save_data.keybindings[action] = event
	ResourceSaver.save(save_data, save_data.save_location)

func get_keybinding(action: StringName) -> InputEvent:
	if save_data.keybindings.has(action):
		return save_data.keybindings[action]
	return null
