extends Area2D
export(Vector2) var direction = Vector2(1,0)
#export(float) var velocity = 200
var health = 100

var Bullet = preload("res://Bullet.tscn")
var Explosion = preload("res://Explosion.tscn")

var since_last_fire = 0

func _ready():
	pass

func _process(delta):
	if Global.player:
		var player = Global.player
		var distance_to_player = (Global.player.global_position - global_position).length()
		if  distance_to_player > 10_000:
			queue_free()
			return
		if distance_to_player < 500: # Field of vision
			$Sprite.look_at(player.global_position)
			# TODO look at slowly
			direction = (Global.player.global_position - global_position).normalized()
			#move_and_collide(direction*velocity*delta)
			if since_last_fire > 0.1 + randf()*0.2:
				var prob = randf()
				if prob > 0.50:
					var bullet = Bullet.instance()
					bullet.from = "enemy"
					bullet.direction = direction
					bullet.global_position = global_position
					bullet.global_rotation = $Sprite.global_rotation
					get_parent().get_parent().get_node("Bullets").add_child((bullet))
				since_last_fire = 0
		since_last_fire += delta
		$HealthBar.value = health
	

func _on_Turret_body_entered(body):
	if body.from == "player":
		health -= body.damage
		body.queue_free()
	if health <= 0:
		var explosion = Explosion.instance()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		var power_up = Global.get_power_up()
		#print(power_up)
		if power_up:
			power_up.global_position = global_position
			#get_parent().add_child(power_up)
			call_deferred("add_power_up", power_up)
		Global.score += 500
		body.queue_free()
		queue_free()

func add_power_up(power_up):
	get_parent().add_child(power_up)
