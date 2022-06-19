extends Control


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_RichTextLabel3_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_RichTextLabel2_meta_clicked(meta):
	OS.shell_open(str(meta))
