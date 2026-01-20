extends Interactable
class_name Talk

@export var timeline: String = "default"

func interact() -> void:
	if Dialogic.current_timeline == null:
		Dialogic.start(timeline)