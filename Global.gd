extends Node


var music_volume = 80
var player = null
var score = 0
var game_over = false

enum {
	NORMAL_GUN,
	DOUBLE_BARREL
}

var current_gun = NORMAL_GUN

func _ready():
	pass
	
func _process(_delta):
	if game_over == true:
		if player:
			player.hide()
		get_tree().paused = true
