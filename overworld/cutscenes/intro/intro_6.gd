extends Node2D

@export var change_scene: String = "InsideHeroRoom"

@onready var conversation: Conversation = $Conversation
@onready var player: Player25D = $Player25D
@onready var skip_button: Button = $SkipButton

var started_interact: bool = false
var finished_interact: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action("open_menu"):
		if !skip_button.visible:
			skip_button.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	conversation.on_body_entered(player)
	skip_button.pressed.connect(on_skip_pressed)

func _process(_delta: float) -> void:
	if !started_interact && !finished_interact && !player.is_paused:
		var interact_event = InputEventAction.new()
		interact_event.action = "interact"
		interact_event.pressed = true
		Input.parse_input_event(interact_event)
	elif !started_interact && !finished_interact && player.is_paused:
		started_interact = true
	elif started_interact && !finished_interact && !player.is_paused:
		finished_interact = true
	elif started_interact && finished_interact:
		SceneManager.change_scene(change_scene)

func on_skip_pressed() -> void:
	SceneManager.change_scene(change_scene)
