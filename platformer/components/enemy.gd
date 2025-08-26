class_name Enemy
extends CharacterBody2D

@export var hitbox_source_layer: int = 0
#Currently this supports fox, wolf, bird, bear, bunny
@export var enemy_type: String = 'fox'
@export var damage: float = 1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play(enemy_type)
