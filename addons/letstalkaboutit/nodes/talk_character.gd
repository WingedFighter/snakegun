extends Node
class_name TalkCharacter

@export var character_id: String = "default"
@export var character_name: String = "Default"
@export var character_base_panel: Texture2D 
@export var character_sad: Texture2D
@export var character_happy: Texture2D
@export var character_angry: Texture2D
@export var character_surprised: Texture2D
@export var character_neutral: Texture2D
@export var character_serious: Texture2D

enum MOOD {
    SAD,
    HAPPY,
    ANGRY,
    SURPRISED,
    NEUTRAL,
    SERIOUS
}

func _ready() -> void:
    add_to_group("TalkCharacter")