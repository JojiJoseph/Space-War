extends Area2D
export(Vector2) var direction = Vector2(randf(),randf()).normalized()
export(float) var velocity = 20


var since_last_fire = 0

func _ready():
	global_rotation += randf()*PI - PI/2

func _process(delta):
	global_position.x += direction.x*delta*velocity
	global_position.y += direction.y*delta*velocity
	if Global.player:
		var player = Global.player
		var distance_to_player = (Global.player.global_position - global_position).length()
		if  distance_to_player > 10_000:
			queue_free()
			return
	


