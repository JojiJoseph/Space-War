extends AnimatedSprite


func _ready():
	frame = 0


func _on_Timer_timeout():
	self.queue_free()
