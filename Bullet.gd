extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var direction = Vector2(1,0)
export(float) var velocity = 1000
export var from = "player"
export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(direction*delta*velocity)
	var player = Global.player
	if player and (player.global_position - global_position).length() > 10_000:
		queue_free()
