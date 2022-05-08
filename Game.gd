extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gun_indicator_sprites = [
	preload("res://art/weapon_hud/bullet.svg"),
	preload("res://art/weapon_hud/double.svg"),
	preload("res://art/weapon_hud/missile.svg")
]
var noise_generator = OpenSimplexNoise.new()
var visited = {}

var Enemy = preload("res://EnemyShip.tscn")
var KillerSat = preload("res://KillerSat.tscn")
var Turret = preload("res://Turret.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.reset()
	Input.set_custom_mouse_cursor(load("res://art/crosshair.svg"),Input.CURSOR_CROSS,Vector2(8,8))
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

	noise_generator.period = 16

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
	if Global.game_over:
		$HUD/PauseScreen.show()
		get_tree().paused = true
	if Global.player:
		repopulate()
		$HUD/WeaponIndicator/TextureRect.texture = gun_indicator_sprites[Global.player.current_gun]
		if Global.player.current_gun == 0:
			$HUD/WeaponIndicator/Count.text = ""
		else:
			$HUD/WeaponIndicator/Count.text = str(Global.player.bullets_available[Global.player.current_gun])
		$HUD/Score.text = "Score : " + str(Global.score)
		$Camera2D.global_rotation = Global.player.global_rotation+ PI/2
		$Camera2D.global_position = Global.player.global_position 
		
func repopulate():

	var player = Global.player
	var xy = Global.player.global_position/64
	xy = [floor(xy[0]),floor(xy[1])]
	var neighbour_delta = [[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0]]

	var current_block = get_current_big_block(player.global_position)

	var difficulty = max(0.2, min(Global.time_elapsed/1800, 1)) / 2
	for delta in neighbour_delta:
		var new_block = [current_block[0] + delta[0], current_block[1] + delta[1]]
		if new_block in visited:
			continue

		visited[new_block] = 1

		for i in range(new_block[0]*64, (1+new_block[0])*64):
			for j in range(new_block[1]*64, (1+new_block[1])*64):
				var ns = noise_generator.get_noise_2d(i, j)

				if 0.0 < ns and ns < 0.4:
					$TileMap.set_cell(i,j,0)
				elif ns >= 0.4:
					$TileMap.set_cell(i,j,1)
				if ns >= 0.8:
					if randf() < difficulty:
						var turret = Turret.instance()
						turret.global_position = Vector2(new_block[0]*64*64 + i*64+32,new_block[1]*64*64 + j*64+32)
						$Enemies.add_child(turret)
						
		for i in range(8):
			for j in range(8):
				if randf() < difficulty:
					if randf() < min(2*difficulty, 0.7):
						var enemy_ship = Enemy.instance()
						var position = Vector2(new_block[0]*64*64 + i * 8 * 64,  new_block[1]*64*64 + j * 8 * 64)
						enemy_ship.global_position = position
						$Enemies.add_child(enemy_ship)
					else:
						var killer_sat = KillerSat.instance()
						var position = Vector2(new_block[0]*64*64 + i * 8 * 64,  new_block[1]*64*64 + j * 8 * 64)
						killer_sat.global_position = position
						$Enemies.add_child(killer_sat)
	# Clean up
	for block in visited:
		# If manhattan distance >= 8, remove that block
		if abs(current_block[0]-block[0]) + abs(current_block[1] - block[1]) >= 8:
			for i in range(block[0]*64, (1+block[0])*64):
				for j in range(block[1]*64, (1+block[1])*64):
					$TileMap.set_cell(i,j,-1)
	
func get_current_big_block(global_position):
	return [floor(global_position.x/64/64), floor(global_position.y/64/64)]
