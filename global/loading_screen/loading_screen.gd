extends Node2D

var load_screen: PackedScene = preload("res://global/loading_screen/loading_screen.tscn")
var load_screen_ref: CanvasLayer

func _ready() -> void:
	load_screen_ref = load_screen.instantiate()
	add_child(load_screen_ref)
	load_screen_ref.visible = false

func start_load() -> void:
	load_screen_ref.visible = true

func stop_load() -> void:
	load_screen_ref.visible = false
