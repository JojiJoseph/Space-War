extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gun_indicator_sprites = [
	preload("res://art/bullet.svg"),
	preload("res://art/double_barrel_indicator.svg")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().change_scene("res://Menu.tscn")
	if Global.player:
		$HUD/WeaponIndicator/TextureRect.texture = gun_indicator_sprites[Global.player.current_gun]
		if Global.player.current_gun == 0:
			$HUD/WeaponIndicator/Count.text = ""
		else:
			$HUD/WeaponIndicator/Count.text = str(Global.player.bullets_available[Global.player.current_gun])
		
