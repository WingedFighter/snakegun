class_name move_component
extends Node2D

@export var speed: int = 100
@export var animation_player: AnimationPlayer
@export var enemy: Enemy
@onready var marker1 = $marker1
@onready var marker2 = $marker2
var pos1: Vector2
var pos2: Vector2
var marker: int = 1
var flip: bool = false

func _ready() -> void:
	# Used since the point will move in space since they're Node2Ds
	pos1 = marker1.global_position
	pos2 = marker2.global_position
	animation_player.play(enemy.enemy_type)

func _physics_process(delta: float) -> void:
	# yeah we're getting hacky with code game jam shit let's goo, f uck a state machine
	if marker == 1:
		enemy.global_position += enemy.global_position.direction_to(pos1) * speed * delta
		# If we haven't flipped the animation yet, flip it
		if !flip:
			if enemy.global_position.x > pos1.x:
				animation_player.play(enemy.enemy_type)
			else:
				animation_player.play(enemy.enemy_type + '_right')
			flip = true
		if enemy.global_position.distance_to(pos1) < 10:
			marker = 2
			flip = false

	if marker == 2:
		enemy.global_position += enemy.global_position.direction_to(pos2) * speed * delta

		if !flip:
			if enemy.global_position.x > pos2.x:
				animation_player.play(enemy.enemy_type)
			else:
				animation_player.play(enemy.enemy_type + '_right')
			flip = true
		if enemy.global_position.distance_to(pos2) < 10:
			marker = 1
			flip = false
	
