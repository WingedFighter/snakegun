class_name Bullet
extends CharacterBody2D

var v: Vector2
var damage: float = 1
@export var hitbox_source_layer: int = 0
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if (v.x < 0):
		sprite.flip_h = true

func _physics_process(_delta: float) -> void:
	velocity = v
	move_and_slide()
