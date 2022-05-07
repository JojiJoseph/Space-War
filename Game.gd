extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gun_indicator_sprites = [
	preload("res://art/bullet.svg"),
	preload("res://art/double_barrel_indicator.svg"),
	preload("res://art/missile.svg")
]
var noise_generator = OpenSimplexNoise.new()
var visited = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(load("res://art/crosshair.svg"),Input.CURSOR_ARROW,Vector2(8,8))
	#Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	# Experimenting with open simplex noise
	noise_generator.period = 16
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(noise_generator.get_image(64, 64))
	#noise_generator.get_image(64,64).save_png("./tile_generic.png")
	#$OpenSimplexNoiseTest.texture = image_texture
	visited[[0,0]] = 1
	for i in 100:
		for j in 100:
			var ns = noise_generator.get_noise_2d(i, j)
			if 0.0 < ns and ns < 0.4:
				$TileMap.set_cell(i,j,0)
			elif ns >= 0.4:
				$TileMap.set_cell(i,j,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().change_scene("res://Menu.tscn")
	if Global.player:
		repopulate()
		$HUD/WeaponIndicator/TextureRect.texture = gun_indicator_sprites[Global.player.current_gun]
		if Global.player.current_gun == 0:
			$HUD/WeaponIndicator/Count.text = ""
		else:
			$HUD/WeaponIndicator/Count.text = str(Global.player.bullets_available[Global.player.current_gun])
		$Camera2D.global_rotation = Global.player.global_rotation+ PI/2
		$Camera2D.global_position = Global.player.global_position 
		
func repopulate():
	# Repopulate the contents of the tilemap
	# Find player coordinate
	# For each coordinate in tilemap:
	# If it is a particular distance away from player, remove tiles
	# For each neighourhood in player visinity,
	# 	if it is not tilemap, create a perlin noise and remove all
	var player = Global.player
	var xy = Global.player.global_position/64
	xy = [floor(xy[0]),floor(xy[1])]
	var neighbour_delta = [[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0]]
	#print(player.global_position/ 8/64)
	var current_block = get_current_big_block(player.global_position)
	#print(current_block)
	#neighbour_delta = [[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[0,-1]]
	for delta in neighbour_delta:
		var new_block = [current_block[0] + delta[0], current_block[1] + delta[1]]
		if new_block in visited:
			continue
		#print(new_block)
		visited[new_block] = 1
		#print(block)
		for i in range(new_block[0]*64, (1+new_block[0])*64):
			for j in range(new_block[1]*64, (1+new_block[1])*64):
				var ns = noise_generator.get_noise_2d(i, j)
				#print(ns)
				if 0.0 < ns and ns < 0.4:
					$TileMap.set_cell(i,j,0)
				elif ns >= 0.4:
					$TileMap.set_cell(i,j,1)
	# Clean up
	for block in visited:
		# If manhattan distance >= 8, remove that block
		if abs(current_block[0]-block[0]) + abs(current_block[1] - block[1]) >= 8:
			for i in range(block[0]*64, (1+block[0])*64):
				for j in range(block[1]*64, (1+block[1])*64):
					$TileMap.set_cell(i,j,-1)
	
func get_current_big_block(global_position):
	return [floor(global_position.x/64/64), floor(global_position.y/64/64)]
