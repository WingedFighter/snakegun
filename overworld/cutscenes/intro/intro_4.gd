extends Node2D

@onready var camera: Camera2D = $Camera2D

@export var change_scene: String = "Intro5"

var start_time: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_time == 0:
		start_time = Time.get_ticks_msec()
	
	if Time.get_ticks_msec() - start_time > 3500:
		SceneManager.change_scene(change_scene)
	else:
		camera.position = camera.position + Vector2(50, 0) * delta
		camera.zoom = camera.zoom + Vector2(1.0, 1.0) * delta