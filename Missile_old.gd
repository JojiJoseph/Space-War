extends KinematicBody2D


var direction: Vector2 = Vector2(0,0)
var velocity = 1000
var type = "missile"

var started = false
onready var Global = get_node("/root/Global")

var Explosion = preload("res://Scenes/Explosion.tscn")
var time_elapsed = 0

func _ready():
	$AudioStreamPlayer2D.volume_db = Global.volume

func _physics_process(delta):
	if started:
		#velocity = velocity - delta*Global.gravity
		if Global.is_laser:
			$SpriteBody.modulate = Color.red
		else:
			$SpriteBody.modulate = Color.transparent
		look_at(global_position + direction)
		rotate(PI/2)
		var collision = move_and_collide(direction*delta*velocity)
		if collision:
			var collider = collision.collider
			#print(collider)
			#print(collider.type)
			if collider.type == "boss":
				collider.health -= 10
				var pose = global_position
				var explosion = Explosion.instance()
				explosion.global_position = pose
				get_parent().add_child(explosion)
				Global.enemy_health = collider.health
				if collider.health <= 0:
					#explosion.pause_mode = Node.PAUSE_MODE_PROCESS
					collider.queue_free()
					Global.game_over = true
				Global.score += 100
				# if not Global.is_laser:
				queue_free()
			elif collision.collider.type == "bomb":
				#Global.bombs -= 1
				var pose = collision.collider.global_position
				collision.collider.queue_free()
				var explosion = Explosion.instance()
				explosion.global_position = pose
				get_parent().add_child(explosion)
				var PowerUp = Global.get_power_up()
				if PowerUp:
					var power_up = PowerUp.instance()
					power_up.global_position = pose
					get_parent().add_child(power_up)
					
				Global.score += 10
				if not Global.is_laser:
					queue_free()
			elif collision.collider.type == "enemy_missile":
				#Global.bombs -= 1
				var pose = collision.collider.global_position
				collision.collider.queue_free()
				var explosion = Explosion.instance()
				explosion.global_position = pose
				get_parent().add_child(explosion)
				var PowerUp = Global.get_power_up()
				if PowerUp:
					var power_up = PowerUp.instance()
					power_up.global_position = pose
					get_parent().add_child(power_up)
					
				Global.score += 10
				if not Global.is_laser:
					queue_free()
			elif collider.type == "powerup":
				Global.score += 10
				collider.queue_free()
				Global.update_power(collision.collider.power)
				if not Global.is_laser:
					queue_free()
			#collider.queue_free()
		#print(global_position)
	time_elapsed += delta
	if time_elapsed > 10:
		queue_free()
