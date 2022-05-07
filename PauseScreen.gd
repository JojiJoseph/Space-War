extends ColorRect


func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = not get_tree().paused
			hide()
		else:
			get_tree().paused = not get_tree().paused
			show()

func _process(delta):
	if Global.game_over:
		$VBoxContainer/Status.text = "Game Over!"
		$VBoxContainer/ResumeButton.hide()
	else:
		$VBoxContainer/Status.text = "Paused!"
		$VBoxContainer/ResumeButton.show()
	$VBoxContainer/Score.text = "Score : " + str(Global.score)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_RestartButton_pressed():
	Global.reset()
	get_tree().change_scene("res://Game.tscn")
	get_tree().paused = false
	hide()


func _on_ResumeButton_pressed():
	hide()
	get_tree().paused = false


func _on_BackButton_pressed():
	Global.reset()
	hide()
	get_tree().change_scene("res://Menu.tscn")
	get_tree().paused = false
