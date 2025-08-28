extends CanvasLayer

@export var health_component: HealthComponent
@onready var layer1 = $"Health Container"
@onready var layer2 = $"Health Container2"

var hearts: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.health_changed.connect(update_healthbar)
	for child in layer1.get_children():
		hearts.append(child)
	for child in layer2.get_children():
		hearts.append(child)

func update_healthbar(old, new) -> void:
	var i: int = 0
	for heart in hearts:
		if i < new:
			heart.visible = true
		else:
			heart.visible = false
		i += 1
	pass
