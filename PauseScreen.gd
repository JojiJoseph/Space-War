extends ColorRect


func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = not get_tree().paused
			hide()
		else:
			get_tree().paused = not get_tree().paused
			show()
