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
	time_elapsed += delta
		
func get_power_up():
	var choice = randi() % 10
	
	var power_up = null
	
	if choice < 5:
		power_up = PowerUp.instance()
		power_up.power = choice
		return power_up
	if not power_up and player and player.health <= 0.4:
		var r = randf()
		if r < 0.5:
			power_up = PowerUp.instance()
			power_up.power = 2
			return power_up
		elif r < 0.75:
			power_up = PowerUp.instance()
			power_up.power = 4
			return power_up
	return null
	
func reset():
	score = 0
	game_over = false
	time_elapsed = 0
	
