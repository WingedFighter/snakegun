class_name Bullet
extends CharacterBody2D

var v: Vector2
var damage: float = 1
@export var hitbox_source_layer: int = 0
@onready var sprite: Sprite2D = $Sprite2D
@onready var world_collider: Area2D = $WorldCollider

func _ready():
	if (v.x < 0):
		sprite.flip_h = true
	world_collider.body_entered.connect(on_world_collision)

func _physics_process(_delta: float) -> void:
	velocity = v
	move_and_slide()
	
	if position.x < -1000 or position.x > 10000:
		queue_free()

func on_world_collision(_body: Node2D) -> void:
	queue_free()
