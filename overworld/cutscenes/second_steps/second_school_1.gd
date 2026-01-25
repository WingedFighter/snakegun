extends Node2D

const VELOCITY: float = 100.0

@export var change_scene = "SecondSchool2"

@onready var player: Player25D = %Player25D
@onready var skip_button: Button = %Player25D/CanvasLayer/SkipButton

var start_conversation: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadingScreen.stop_load()
	State.flags['in_cutscene'] = true
	State.flags['start_conversation'] = false
	AudioManager.play_music("SchoolDay")
	player.is_paused = true
	Dialogic.timeline_ended.connect(on_timeline_ended)
	skip_button.pressed.connect(on_skip_pressed)
	skip_button.visible = false

func _process(delta: float) -> void:
	if player.position.y < 260.0:
		player.position.y += VELOCITY * delta
	elif !start_conversation:
		skip_button.visible = true
		State.flags['start_conversation'] = true
		var interact_event = InputEventAction.new()
		interact_event.action = "interact"
		interact_event.pressed = true
		Input.parse_input_event(interact_event)
		start_conversation = true

func on_timeline_ended() -> void:
	Dialogic.Inputs.auto_skip.enabled = false
	SceneManager.change_scene(change_scene)

func on_skip_pressed() -> void:
	Dialogic.Inputs.auto_skip.enabled = !Dialogic.Inputs.auto_skip.enabled
