extends TextureProgress


func _ready():
	pass

func _process(delta):
	if value <= 40:
		tint_progress = Color.red
	else:
		tint_progress = Color.green
