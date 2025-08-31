extends Control

@export var to_scene: String = "PostNuke"

@onready var video: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_button: Button = $CanvasLayer/SkipButton

func _ready() -> void:
	skip_button.pressed.connect(on_skip_pressed)
	State.flags['nuke'] = true
	
	# Which music to play?
	# AudioManager.play_music("ImAMagicalGirl")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		skip_button.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !video.is_playing():
		SceneManager.change_scene(to_scene)

func on_skip_pressed() -> void:
	SceneManager.change_scene(to_scene)