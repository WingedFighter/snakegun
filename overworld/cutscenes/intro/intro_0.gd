extends Node2D

@onready var camera: Camera2D = $Camera2D

@export var change_scene: String = "Intro1"

var start_time: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_time == 0:
		start_time = Time.get_ticks_msec()
	
	if Time.get_ticks_msec() - start_time > 3000:
		SceneManager.change_scene(change_scene)
	else:
		camera.position = camera.position + Vector2(0, 50) * delta