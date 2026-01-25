extends Node2D

@export var change_scene: String = "InsideHeroRoom"
@export var timeline: String = "introduction"

@onready var player: Player25D = $Player25D
@onready var skip_button: Button = $CanvasLayer/SkipButton
@onready var tutorial: CanvasLayer = $Tutorial

var started_interact: bool = false
var finished_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_ended.connect(on_timeline_ended)
	skip_button.pressed.connect(on_skip_pressed)
	AudioManager.play_music("SomewhereInIdaho")
	Dialogic.start(timeline)
	get_viewport().set_input_as_handled()

func on_timeline_ended() -> void:
	Dialogic.Inputs.auto_skip.enabled = false
	SceneManager.change_scene(change_scene)

func on_skip_pressed() -> void:
	Dialogic.Inputs.auto_skip.enabled = !Dialogic.Inputs.auto_skip.enabled