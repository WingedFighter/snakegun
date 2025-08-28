extends Control

@export var to_scene: String = "MagicalGurl"

@onready var video: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_button: Button = $CanvasLayer/SkipButton

func _ready() -> void:
	skip_button.pressed.connect(on_skip_pressed)
	State.flags['transformation'] = true
	Quests.complete_quest("Magical Gurl")
	Quests.add_quest({"name": "Night Night", "contents": "Go to bed (Do you remember where you live?)"})


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		skip_button.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !video.is_playing():
		SceneManager.change_scene(to_scene)

func on_skip_pressed() -> void:
	SceneManager.change_scene(to_scene)