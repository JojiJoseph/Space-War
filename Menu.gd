extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_HelpButton_pressed():
	get_tree().change_scene("res://Help.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Settings.tscn")
