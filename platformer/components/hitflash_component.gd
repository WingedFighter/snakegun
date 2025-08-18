extends Node

var sprites: Array[Sprite2D]
var animated_sprites: Array[AnimatedSprite2D]

@export var health_component: HealthComponent
@onready var timer: Timer = $Timer

func _ready() -> void:
	health_component.health_lost.connect(flash)
	timer.timeout.connect(fix_color)
	for node in get_children():
		if node is Sprite2D:
			sprites.append(node)
		if node is AnimatedSprite2D:
			animated_sprites.append(node)

func flash():
	for sprite in sprites:
		sprite.modulate = Color.RED
	for sprite in animated_sprites:
		sprite.modulate = Color.RED
	timer.start(0.1)
	pass

func fix_color():
	for sprite in sprites:
		sprite.modulate = Color.WHITE
	for sprite in animated_sprites:
		sprite.modulate = Color.WHITE
	pass
