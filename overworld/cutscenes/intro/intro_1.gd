extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var change_scene: String = "Intro2"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !animation_player.is_playing():
		SceneManager.change_scene(change_scene)