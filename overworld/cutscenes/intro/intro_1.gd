extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skip_button: Button = $Camera2D/SkipButton

@export var change_scene: String = "Intro2"
@export var final_skip: String = "InsideHeroRoom"

func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		if !skip_button.visible:
			skip_button.visible = true

func _ready() -> void:
	skip_button.pressed.connect(on_skip_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !animation_player.is_playing():
		SceneManager.change_scene(change_scene)

func on_skip_pressed() -> void:
	SceneManager.change_scene(final_skip)