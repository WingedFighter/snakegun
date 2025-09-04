extends Node2D

@export var to_scene: String = "InsideHeroRoom"

@onready var player: Player25D = $Player25D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player.is_paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !animation_player.is_playing():
		State.flags['sleep'] = true
		State.flags['can_sleep'] = false
		SceneManager.change_scene(to_scene)