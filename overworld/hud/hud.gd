extends Control
class_name HUD25D

@onready var talk_display := $CanvasLayer/TalkDisplay

var last_interactable: Node
var interacting: bool = false

func _input(event: InputEvent) -> void:
	if interacting:
		if talk_display.can_transition:
			if event.is_action_pressed("interact"):
				talk_display.interaction(last_interactable)
		else:
			if !talk_display.is_choosing && event.is_action_pressed("interact"):
				talk_display.interaction(talk_display.current_interactable)
	elif event.is_action_pressed("interact") && last_interactable is Interactable:
		if talk_display.can_interact(last_interactable):
			talk_display.interaction(last_interactable)
			interacting = true
