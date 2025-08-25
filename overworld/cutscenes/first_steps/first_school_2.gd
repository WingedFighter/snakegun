extends Node2D

const VELOCITY = 10.0

@export var change_scene: String = "OutsideTownSchool"

@onready var player: Player25D = %Player25D
@onready var skip_button: Button = $CanvasLayer/SkipButton

var start_conversation: bool = false
var frame_count: int = 0
var frame_limit: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	State.flags['in_cutscene'] = true
	State.flags['start_conversation'] = false
	AudioManager.play_music("SchoolDay")
	player.is_paused = true
	skip_button.pressed.connect(end_cutscene)

func _process(_delta: float) -> void:
	if frame_count < frame_limit:
		frame_count += 1
	elif !start_conversation:
		State.flags['start_conversation'] = true
		var interact_event = InputEventAction.new()
		interact_event.action = "interact"
		interact_event.pressed = true
		Input.parse_input_event(interact_event)
		start_conversation = true
	elif !player.is_paused:
		end_cutscene()

func end_cutscene() -> void:
	State.flags['in_cutscene'] = false
	State.flags['first_steps'] = false
	State.flags.erase('start_conversation')
	Quests.complete_quest("First Steps")
	Quests.add_quest({"name": "Magical Gurl", "contents": "Go to the forest (East of the school)"})
	SceneManager.change_scene(change_scene)