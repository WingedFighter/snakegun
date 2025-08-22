extends Node2D

@export var change_scene: String = "InsideHeroRoom"

@onready var conversation: Conversation = $Conversation
@onready var player: Player25D = $Player25D

var started_interact: bool = false
var finished_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	conversation.on_body_entered(player)

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
