extends Node2D

const VELOCITY: float = 100.0

var start_conversation: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadingScreen.stop_load()
	State.flags['in_cutscene'] = true
	State.flags['start_conversation'] = false
	AudioManager.play_music("SchoolDay")

func _process(delta: float) -> void:
	if %Player25D.position.y < 260.0:
		%Player25D.position.y += VELOCITY * delta
	elif !start_conversation:
		State.flags['start_conversation'] = true
		var interact_event = InputEventAction.new()
		interact_event.action = "interact"
		interact_event.pressed = true
		Input.parse_input_event(interact_event)
		start_conversation = true
	elif !$Player25D.is_paused:
		SceneManager.change_scene("MainTitle")
