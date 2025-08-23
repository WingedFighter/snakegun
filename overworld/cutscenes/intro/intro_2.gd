extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var skip_button: Button = $Camera2D/SkipButton

@export var change_scene: String = "Intro3"
@export var final_skip: String = "InsideHeroRoom"

var start_time: int = 0

func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		if !skip_button.visible:
			skip_button.visible = true

func _ready() -> void:
	skip_button.pressed.connect(on_skip_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_time == 0:
		start_time = Time.get_ticks_msec()
	
	if Time.get_ticks_msec() - start_time > 3500:
		SceneManager.change_scene(change_scene)
	else:
		camera.position = camera.position + Vector2(150, 0) * delta

func on_skip_pressed() -> void:
	SceneManager.change_scene(final_skip)