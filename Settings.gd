extends Control


var updation_in_progress = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var music_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	#music_volume = (music_volume + 72)/78 * 100
	$GridContainer/HSlider.value = music_volume
	$GridContainer/MusicVolume.text = str(int(music_volume))
	var sfx_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	#sfx_volume = (sfx_volume + 72)/78 * 100
	$GridContainer/HSlider2.value = sfx_volume
	$GridContainer/SfxVolume.text = str(int(sfx_volume))
	updation_in_progress = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_HSlider_value_changed(value):
	if value == -80:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		$GridContainer/MusicVolume.text = "-80"
	else:
		#var music_volume = -72 + value/100*78
		$GridContainer/MusicVolume.text = str(value)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_HSlider_focus_entered():
	if not updation_in_progress:
		$BackgroundMusic.playing = true


func _on_HSlider_focus_exited():
	if not updation_in_progress:
		$BackgroundMusic.playing = false


func _on_HSlider2_value_changed(value):
	if value == -80:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		$GridContainer/MusicVolume.text = "0"
	else:
		#var sfx_volume = -72 + value/100*78
		$GridContainer/SfxVolume.text = str(value)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
		if not $"SFX Music".playing and not updation_in_progress:
			$"SFX Music".play()
