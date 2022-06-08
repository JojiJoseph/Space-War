extends Control

var waiting_for_input = false

var rebind_button = false
var rebind_action = null
var rebind_event = null

func _ready():
#	for action in InputMap.get_actions():
	for action in ["forward", "backward", "left", "right", "fire", "next_weapon", "prev_weapon", "pause"]:
		if not action.begins_with("ui_"):
			var label = Label.new()
			label.text = action
			$VBoxContainer/GridContainer.add_child(label)
			var action_list = InputMap.get_action_list(action)
			var action_button = Button.new()
			var evt = action_list[0]
			action_button.text = get_event_text(evt)
			action_button.size_flags_horizontal |= SIZE_EXPAND
			$VBoxContainer/GridContainer.add_child(action_button)
			action_button.connect("pressed",self,"action_button_pressed", [action_button, action, evt])
			action_button = Button.new()
			if len(action_list) > 1:
				evt = action_list[1]
				action_button.text = get_event_text(evt)
				action_button.size_flags_horizontal |= SIZE_EXPAND
			else:
				evt = null
				action_button.text = "..."
			$VBoxContainer/GridContainer.add_child(action_button)
			action_button.connect("pressed",self,"action_button_pressed", [action_button, action, evt])
	$VBoxContainer/HBoxContainer/OptionButton.add_item("Relative to character")
	$VBoxContainer/HBoxContainer/OptionButton.add_item("Relative to observer")
	if Global.relative_to_observer:
		$VBoxContainer/HBoxContainer/OptionButton.selected = 1

func action_button_pressed(btn, action, evt):
	waiting_for_input = true
	if rebind_button:
		rebind_button.modulate = Color.white
	rebind_button = btn
	rebind_event = evt
	rebind_action = action
	btn.modulate = Color.green
	
func _input(event):
	#return
	if (event is InputEventKey or event is InputEventMouseButton) and waiting_for_input:
		if rebind_event != null:
			InputMap.action_erase_event(rebind_action, rebind_event)
		print(rebind_action)
		InputMap.action_add_event(rebind_action, event)
		rebind_button.text = get_event_text(event)
		waiting_for_input = false 


func _on_ResetToDefaultButton_pressed():
	Global.relative_to_observer = false
	InputMap.load_from_globals()
	get_tree().reload_current_scene()
	
func get_event_text(event):
	if event is InputEventKey:
		return event.as_text()
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				return "Left Click"
			BUTTON_RIGHT:
				return "Right Click"
			BUTTON_MIDDLE:
				return "Middle Click"
			BUTTON_WHEEL_UP:
				return "Wheel Up"
			BUTTON_WHEEL_DOWN:
				return "Wheel Down"
	return event.as_text()
func _on_OptionButton_item_selected(index):
	if index == 1:
		Global.relative_to_observer = true
	else:
		Global.relative_to_observer = false
