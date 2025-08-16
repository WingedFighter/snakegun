extends Control
class_name HUD25D

@onready var talk_display := $CanvasLayer/TalkDisplay
@onready var escape_menu := $CanvasLayer/EscapeMenu

signal interact_start
signal interact_end

var last_interactable: Node
var is_interacting: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_interacting:
			if talk_display.can_transition:
				talk_display.interaction(last_interactable)
			elif !talk_display.is_choosing:
					talk_display.interaction(talk_display.current_interactable)
		elif last_interactable is Transition:
			last_interactable.interact()
		elif last_interactable is Conversation:
			if talk_display.can_interact(last_interactable):
				talk_display.interaction(last_interactable)
				last_interactable.get_node("TalkManager").conversation_end.connect(on_conversation_end)
				interact_start.emit()
				is_interacting = true
	
	if event.is_action_pressed("open_menu"):
		if !escape_menu.visible:
			escape_menu.open()
		else:
			escape_menu.close()

func on_conversation_end(node: Node):
	is_interacting = false
	if node is Conversation:
		node.get_node("TalkManager").conversation_end.disconnect(on_conversation_end)
	interact_end.emit()

func is_valid_interactable() -> bool:
	if last_interactable is Interactable && !is_interacting:
		return true
	return false