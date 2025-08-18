class_name Bullet
extends CharacterBody2D

var v: Vector2
var damage: float = 1

func _physics_process(_delta: float) -> void:
	velocity = v
	move_and_slide()
