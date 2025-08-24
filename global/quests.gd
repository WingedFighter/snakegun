extends Node

var list: Array[Dictionary]

func _ready() -> void:
    SaveManager.load_data()

    if len(SaveManager.save_data.quests_list) > 0:
        list = SaveManager.save_data.quests_list

func add_quest(quest: Dictionary[String, String]) -> void:
    list.append(quest)

func complete_quest(quest_name: String) -> void:
    var index := 0
    for quest in list:
        if quest['name'] == quest_name:
            list.pop_at(index)
            return
        else:
            index += 1