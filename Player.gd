extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("forward"):
		var delta_position = (get_global_mouse_position()-global_position)*delta;
		move_and_collide(delta_position)
