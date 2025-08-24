extends CharacterBody2D
class_name Player25D

@export var speed := 15000.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud: Control = $HUD
@onready var bubble: AnimatedSprite2D = $Bubble

var is_paused: bool = false
var is_escape_pause: bool = false

func _ready() -> void:
	hud.interact_start.connect(pause)
	hud.interact_end.connect(resume)

func _physics_process(delta: float) -> void:
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")

	var movement = Vector2.ZERO

	if !is_paused && !is_escape_pause:
		movement = Vector2(horizontal, vertical)
		velocity = delta * movement * speed
	else:
		velocity = Vector2.ZERO
	
	bubble.visible = hud.is_valid_interactable()

	move_and_slide()
	update_animations(movement)

func update_animations(movement: Vector2) -> void:
	if movement.y < 0:
		animated_sprite_2d.play("move_up")
	elif movement.y > 0:
		animated_sprite_2d.play("move_down")
	else:
		if movement.x > 0:
			animated_sprite_2d.play("move_right")
		elif movement.x < 0:
			animated_sprite_2d.play("move_left")
	
	if movement == Vector2.ZERO:
		match animated_sprite_2d.animation:
			"move_up":
				animated_sprite_2d.play("idle_up")
			"move_down":
				animated_sprite_2d.play("idle_down")
			"move_left":
				animated_sprite_2d.play("idle_left")
			"move_right":
				animated_sprite_2d.play("idle_right")
			_:
				animated_sprite_2d.play("idle_down")

func pause() -> void:
	is_paused = true

func resume() -> void:
	is_paused = false

func escape_pause() -> void:
	is_escape_pause = true
	hud.pause()

func escape_unpause() -> void:
	is_escape_pause = false
	hud.unpause()