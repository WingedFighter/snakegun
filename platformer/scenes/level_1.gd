extends Node2D

@export var to_scene: String = "PreBoss1"

@onready var end_of_level: Area2D = $EndOfLevel

func _ready():
	end_of_level.end_of_level.connect(on_level_end)

func on_level_end() -> void:
	SceneManager.change_scene(to_scene)
