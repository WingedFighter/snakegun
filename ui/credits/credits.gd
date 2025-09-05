extends Node2D

@export var initial_pause: int = 4
@export var scroll_speed: int = 100

@onready var camera: Camera2D = $Camera2D
@onready var thanks: Label = $Thanks

var timer: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("FinalBossReal")
	await get_tree().create_timer(initial_pause).timeout
	timer = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera.position.y > thanks.position.y:
		pass
	elif timer:
		camera.position.y += scroll_speed * delta