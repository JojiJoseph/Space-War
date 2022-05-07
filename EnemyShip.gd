extends KinematicBody2D

export(Vector2) var direction = Vector2(1,0)
export(float) var velocity = 200
var health = 100

var Bullet = preload("res://Bullet.tscn")

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
		if distance_to_player < 1000: # Field of vision
			look_at(player.global_position)
			# TODO look at slowly
			direction = (Global.player.global_position - global_position).normalized()
		if distance_to_player < 200: # Enemy knows it's dangerous colliding with player
			direction = -(Global.player.global_position - global_position).normalized()
		move_and_collide(direction*velocity*delta)
		if since_last_fire > 0.4:
			var prob = randf()
			if prob > 0.50:
				var bullet = Bullet.instance()
				bullet.from = "enemy"
				bullet.direction = direction
				bullet.global_position = global_position
				bullet.global_rotation = global_rotation
				get_parent().add_child((bullet))
			since_last_fire = 0
		since_last_fire += delta
	




func _on_BulletHitBox_body_entered(body):
	if body.from == "player":
		body.queue_free()
		health -= 10
	if health <= 0:
		body.queue_free()
		queue_free()
