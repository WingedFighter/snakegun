extends Control
class_name HUD25D

@onready var talk_display := $CanvasLayer/TalkDisplay

signal interact_start
signal interact_end

var last_interactable: Node
var is_interacting: bool = false

func _input(event: InputEvent) -> void:
	if is_interacting:
		if talk_display.can_transition:
			if event.is_action_pressed("interact"):
				talk_display.interaction(last_interactable)
		else:
			if !talk_display.is_choosing && event.is_action_pressed("interact"):
				talk_display.interaction(talk_display.current_interactable)
	elif event.is_action_pressed("interact") && last_interactable is Interactable:
		if talk_display.can_interact(last_interactable):
			talk_display.interaction(last_interactable)
			last_interactable.get_node("TalkManager").conversation_end.connect(on_conversation_end)
			interact_start.emit()
			is_interacting = true

func on_conversation_end(node: Node):
	is_interacting = false
	if node is Interactable:
		node.get_node("TalkManager").conversation_end.disconnect(on_conversation_end)
	interact_end.emit()