extends Node

var list: Array[Dictionary]

func _ready() -> void:
    SaveManager.load_data()

    if len(SaveManager.save_data.quests_list) > 0:
        list = SaveManager.save_data.quests_list