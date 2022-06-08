extends Control


var updation_in_progress = true

func _ready():
	var music_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var music_volume = db2linear(music_volume_db) * 100
	$GridContainer/HSlider.value = music_volume
	$GridContainer/MusicVolume.text = str(int(music_volume))
	
	var sfx_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	var sfx_volume = db2linear(sfx_volume_db) * 100
	$GridContainer/HSlider2.value = sfx_volume
	$GridContainer/SfxVolume.text = str(int(sfx_volume))
	
	updation_in_progress = false
	
func _process(delta):
	if not visible:
		$BackgroundMusic.playing = false
		$"SFX Music".playing = false


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_HSlider_value_changed(value):
	var volume_db = linear2db(value/100)
	$GridContainer/MusicVolume.text = str(value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)




func _on_HSlider_focus_entered():
	if not updation_in_progress:
		$BackgroundMusic.playing = true


func _on_HSlider_focus_exited():
	if not updation_in_progress:
		$BackgroundMusic.playing = false


func _on_HSlider2_value_changed(value):
	var volume_db = linear2db(value/100)
	$GridContainer/SfxVolume.text = str(value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db)
	if not $"SFX Music".playing and not updation_in_progress:
		$"SFX Music".play()



