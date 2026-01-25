extends Node

var flags: Dictionary[String, bool] = {}

func end_conversation() -> void:
    State.flags['in_cutscene'] = false
    State.flags.erase('start_conversation')
