extends Control

@export var action_skip_list = [
	"click"
]

@onready var input_list: GridContainer = $Margin/Panel/VBoxContainer/InputList
@onready var close_button: Button = $Margin/Panel/VBoxContainer/Button
@onready var waiting: PanelContainer = $Waiting

var input_actions: Array
var button_to_change: TextureButton

func _ready() -> void:
	close_button.pressed.connect(on_close_pressed)
	var temp_actions = InputMap.get_actions()
	for action in temp_actions:
		if action_skip_list.has(action):
			continue
		if !action.begins_with("ui"):
			input_actions.append(action)
	# if TransitionHandler.load_keybindings:
	# 	load_data()
	# 	TransitionHandler.load_keybindings = false
	# else:
	for action in input_actions:
		var button = input_hbox(action)
		button.pressed.connect(on_button_press.bind(button))

func _input(event: InputEvent) -> void:
	if button_to_change == null:
		pass
	elif event is InputEventKey || event is InputEventMouseButton:
		for action in input_actions:
			var events = InputMap.action_get_events(action)
			if events != []:
				var old_event = InputMap.action_get_events(action)[0]
				if event is InputEventMouseButton:
					if old_event is InputEventMouseButton:
						if old_event.button_index == event.button_index:
							InputMap.action_erase_events(action)
				else:
					if old_event is InputEventKey:
						if old_event.as_text_physical_keycode() == event.as_text_physical_keycode():
							InputMap.action_erase_events(action)
		if InputMap.action_get_events(button_to_change.name) != []:
			InputMap.action_erase_events(button_to_change.name)
		InputMap.action_add_event(button_to_change.name, event)
		button_to_change = null
		waiting.visible = false
		for child in input_list.get_children():
			child.queue_free()
		for new_action in input_actions:
			var button = input_hbox(new_action)
			button.pressed.connect(on_button_press.bind(button))

func load_data() -> void:
	for child in input_list.get_children():
		child.queue_free()
	for action in input_actions:
		var current_event = InputMap.action_get_events(action)
		var new_event = SaveManager.get_keybinding(action)
		var compared = compare_events(current_event, new_event)
		if new_event == null:
			SaveManager.save_keybinding(action, current_event[0])
		elif new_event is InputEventKey && !compared:
			InputMap.action_erase_event(action, current_event[0])
			InputMap.action_add_event(action, new_event)
			SaveManager.save_keybinding(action, new_event)
		elif new_event is InputEventMouseButton && !compared:
			InputMap.action_erase_event(action, current_event[0])
			InputMap.action_add_event(action, new_event)
			SaveManager.save_keybinding(action, new_event)
		var button = input_hbox(action)
		button.pressed.connect(on_button_press.bind(button))

func compare_events(event_1, event_2) -> bool:
	if event_1 == null || event_2 == null:
		return false
	else:
		if event_1 is InputEventKey:
			if event_2 is InputEventMouseButton:
				return false
			else:
				if event_1.as_text_physical_keycode() == event_2.as_text_physical_keycode():
					return true
		elif event_1 is InputEventMouseButton:
			if event_2 is InputEventKey:
				return false
			else:
				if event_1.button_index == event_2.button_index:
					return true
				
	return false

func on_button_press(button: TextureButton):
	button_to_change = button
	waiting.visible = true

func on_close_pressed():
	visible = false

func input_hbox(input_name: StringName) -> TextureButton:
	var panel = PanelContainer.new()
	input_list.add_child(panel)
	panel.set_theme_type_variation("BlackPanelContainer")
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var hbox = HBoxContainer.new()
	panel.add_child(hbox)
	var label = Label.new()
	hbox.add_child(label)
	label.text = input_name.replace("_", " ")
	label.add_theme_font_size_override("font_size", 16)
	var spacer = Control.new()
	hbox.add_child(spacer)
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var button = TextureButton.new()
	hbox.add_child(button)
	button.name = input_name
	var event = InputMap.action_get_events(input_name)
	if event != []:
		event = event[0]
		# TransitionHandler.save_keybinding(input_name, event)
		if event is InputEventKey:
			var keycode = event.as_text_physical_keycode().to_lower()
			if keycode == "up" || keycode == "down" || keycode == "left" || keycode == "right":
				keycode = "arrow_" + keycode
			var filename_normal = "res://ui/icons/keyboard_mouse/keyboard_" + keycode + ".png"
			var filename_pressed = "res://ui/icons/keyboard_mouse/keyboard_" + keycode + "_outline.png"
			button.texture_normal = load(filename_normal)
			button.texture_pressed = load(filename_pressed)
		elif event is InputEventMouseButton:
			var filename_normal
			var filename_pressed
			match event.button_index:
				1:
					filename_normal = "res://ui/icons/keyboard_mouse/mouse_left.png"
					filename_pressed = "res://ui/icons/keyboard_mouse/mouse_left_outline.png"
				2:
					filename_normal = "res://ui/icons/keyboard_mouse/mouse_right.png"
					filename_pressed = "res://ui/icons/keyboard_mouse/mouse_right_outline.png"
				4:
					filename_normal = "res://ui/icons/keyboard_mouse/mouse_scroll_up.png"
					filename_pressed = "res://ui/icons/keyboard_mouse/mouse_left_outline.png"
				5:
					filename_normal = "res://ui/icons/keyboard_mouse/mouse_scroll_down.png"
					filename_pressed = "res://ui/icons/keyboard_mouse/mouse_left_outline.png"
			button.texture_normal = load(filename_normal)
			button.texture_pressed = load(filename_pressed)
		else:
			button.texture_normal = load("res://ui/icons/keyboard_mouse/generic_button_square.png")
			button.texture_pressed = load("res://ui/icons/keyboard_mouse/generic_button_square_outline.png")
	else:
		button.texture_normal = load("res://ui/icons/keyboard_mouse/generic_button_square.png")
		button.texture_pressed = load("res://ui/icons/keyboard_mouse/generic_button_square_outline.png")
	return button
