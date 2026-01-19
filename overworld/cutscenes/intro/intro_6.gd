extends Node2D

@export var change_scene: String = "InsideHeroRoom"

@onready var conversation: Conversation = $Conversation
@onready var player: Player25D = $Player25D
@onready var skip_button: Button = $CanvasLayer/SkipButton
@onready var tutorial: CanvasLayer = $Tutorial

var started_interact: bool = false
var finished_interact: bool = false

func _input(event: InputEvent) -> void:
	if Dialogic.current_timeline != null:
		return

	if event.is_action("interact"):
		Dialogic.start('introduction_timeline')
		get_viewport().set_input_as_handled()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_ended.connect(on_timeline_ended)
	if len(AudioManager.music_dictionary) > 0:
		AudioManager.play_music("SomewhereInIdaho")

func _process(_delta: float) -> void:
	if !started_interact && !finished_interact && !player.is_paused:
		var interact_event = InputEventAction.new()
		interact_event.action = "interact"
		interact_event.pressed = true
		Input.parse_input_event(interact_event)

func on_timeline_ended() -> void:
	SceneManager.change_scene(change_scene)