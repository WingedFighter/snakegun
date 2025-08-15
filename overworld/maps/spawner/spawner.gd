extends Node2D

@export var spawns: Dictionary[String, NodePath]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var previous_scene = SceneManager.get_previous_scene()
	if spawns.has(previous_scene):
		var spawn_node = get_node(spawns[previous_scene])
		if spawn_node is Marker2D:
			%Player25D.position = spawn_node.position
