extends Node2D

@export var shots_to_transition: int = 5
@export var to_scene: String = "PostTutorial"

@onready var shoot_component = $Player/ShootComponent
@onready var shoot_label = $FirstTimePlaying/ShootLabel

var num_shots = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_component.shot.connect(on_shot)

func on_shot() -> void:
	num_shots += 1
	shoot_label.text = "Shoot " + str(num_shots) + "/" + str(shots_to_transition)
	if num_shots >= shots_to_transition:
		SceneManager.change_scene(to_scene)
