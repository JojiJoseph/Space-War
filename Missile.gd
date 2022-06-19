extends KinematicBody2D


export(Vector2) var direction = Vector2(1,0)
export(float) var velocity = 1000
export var from = "player"
export var damage = 50



func _process(delta):
	move_and_collide(direction*delta*velocity)
	var player = Global.player
	if player and (player.global_position - global_position).length() > 10_000:
		queue_free()
