extends Node2D

const VELOCITY = 10.0

@export var change_scene_2: String = "Nuked"
@export var change_scene_1: String = "Killed"

@onready var player: Player25D = %Player25D
@onready var skip_button: Button = $CanvasLayer/SkipButton
@onready var talk_manager: TalkManager = $Conversation/TalkManager

var start_conversation: bool = false
var frame_count: int = 0
var frame_limit: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play("FinalBossDialogue")
	State.flags['in_cutscene'] = true
	State.flags['start_conversation'] = false
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
	State.flags.erase('start_conversation')
	if len(talk_manager.talk_state.flags) == 0 || talk_manager.talk_state.flags['did_it'] == 'true':
		SceneManager.change_scene(change_scene_2)
	else:
		SceneManager.change_scene(change_scene_1)
