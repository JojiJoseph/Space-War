extends Area2D

enum {
	DOUBLE,
	KILL_ALL,
	HEALTH,
	MISSILE,
	ARMOUR
}

export(int) var power = DOUBLE

var powerup_sprites = [
	preload("res://art/power_ups/power_up_double.svg"),
	preload("res://art/power_ups/power_up_kill_all.svg"),
	preload("res://art/power_ups/power_up_life.svg"),
	preload("res://art/power_ups/power_up_missile.svg"),
	preload("res://art/power_ups/power_up_armour.svg")
]

func _ready():
	if power >= len(powerup_sprites):
		print_debug("Invalid powerup index")
		queue_free()
		return
	$Sprite.texture = powerup_sprites[power]
	
	
func _process(_delta):
	if Global.player:
		if (Global.player.global_position - global_position).length() > 10_000:
			queue_free()
