extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $HitflashComponent/AnimatedSprite2D
@onready var timer: Timer = $DeathTimer
@export var boss_level: int = 1

func _ready() -> void:
	health_component.health_depleted.connect(on_death)
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(scene_transition)

func on_death() -> void:
	sprite.play("death")
	timer.start(1)
	timer.paused = false

func scene_transition() -> void:
	SceneManager.change_scene("PostBoss" + str(boss_level))
