class_name Enemy
extends CharacterBody2D

@export var hitbox_source_layer: int = 1
# Currently this supports fox, wolf, bird, bear, bunny
# Logic for actually using this comes in move component.. blah fuck reusability
@export var enemy_type: String = 'fox'
@export var damage: float = 1
@export var enemy_level: int = 1
