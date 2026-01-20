extends Control
class_name HUD25D

@onready var escape_menu := $CanvasLayer/EscapeMenu

var last_interactable: Node
var is_interacting: bool = false
var is_paused: bool = false

func _input(event: InputEvent) -> void:
	if !is_paused && event.is_action_pressed("interact"):
		if last_interactable is Talk:
			last_interactable.interact()
	
	if event.is_action_pressed("open_menu"):
		if !escape_menu.visible:
			escape_menu.open()
		else:
			escape_menu.close()

func pause() -> void:
	is_paused = true

func unpause() -> void:
	is_paused = false

func is_valid_interactable() -> bool:
	if last_interactable is Interactable:
		if last_interactable.conditional:
			if State.flags.has(last_interactable.condition) && State.flags[last_interactable.condition]:
				return true
			else:
				return false
		else:
			return true
	return false
