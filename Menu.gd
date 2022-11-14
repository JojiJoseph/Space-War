extends Control


func _ready():
	Input.set_custom_mouse_cursor(load("res://art/arrow.svg"),Input.CURSOR_ARROW)


func _on_StartButton_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_HelpButton_pressed():
	get_tree().change_scene("res://Help.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Settings.tscn")
