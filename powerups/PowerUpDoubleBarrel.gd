extends Area2D

var power = "double"

func _ready():
	pass
	
func _process(delta):
	if Global.player:
		if (Global.player.global_position - global_position).length() > 10_000:
			queue_free()
