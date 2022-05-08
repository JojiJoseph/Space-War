extends Node


var music_volume = 80
var player = null
var score = 0
var game_over = false
var time_elapsed = 0

var PowerUp = preload("res://powerups/PowerUp.tscn")

enum {
	NORMAL_GUN,
	DOUBLE_BARREL
}

var current_gun = NORMAL_GUN

func _ready():
	pass
	
func _process(delta):
	if game_over == true:
		if player:
			player.hide()
		#get_tree().paused = true
	time_elapsed += delta
		
func get_power_up():
	var choice = randi() % 4
	
	if choice < 4:
		var power_up = PowerUp.instance()
		power_up.power = choice
		return power_up
	return null
	
func reset():
	score = 0
	game_over = false
	time_elapsed = 0
	
