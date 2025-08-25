extends Control
class_name QuestList

const FRAME_SKIP: int = 10

@onready var v_box: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer

@export var font: Font = preload("res://ui/fonts/Exo2-ExtraBoldItalic.ttf")
@export var font_color: Color = Color.WHITE

var frame_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SceneManager.get_previous_scene().contains("Intro"):
		visible = false
	
func _process(_delta: float) -> void:
	if frame_count < FRAME_SKIP:
		frame_count += 1
	else:
		frame_count = 0

		delete_quests()

		for quest in Quests.list:
			display_quest(quest)
		
		if State.flags.has("in_cutscene") && State.flags['in_cutscene']:
			visible = false
		elif State.flags.has("in_cutscene"):
			visible = true

func delete_quests() -> void:
	for child in v_box.get_children():
		if child.name != "Quests":
			child.queue_free()

func display_quest(quest: Dictionary[String, String]) -> void:
	var new_quest := Label.new()

	v_box.add_child(new_quest)
	new_quest.label_settings = LabelSettings.new()
	new_quest.label_settings.font = font
	new_quest.label_settings.font_color = font_color
	new_quest.text = str(quest['name']) + ": " + str(quest['contents'])
