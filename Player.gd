extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")

var direction = Vector2(1,0)

var since_last_fire = 0

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
	direction = (get_global_mouse_position()-global_position).normalized()
	if Input.is_action_pressed("forward"):
		var delta_position = (get_global_mouse_position()-global_position)*delta;
		move_and_collide(delta_position)
	if Input.is_action_pressed("backward"):
		var delta_position = -(get_global_mouse_position()-global_position)*delta;
		move_and_collide(delta_position)
	if Input.is_action_pressed("left"):
		var delta_position = (get_global_mouse_position()-global_position).rotated(-PI/2) * delta
		move_and_collide(delta_position)
	if Input.is_action_pressed("right"):
		var delta_position = (get_global_mouse_position()-global_position).rotated(PI/2) * delta
		move_and_collide(delta_position)
	if Input.is_action_pressed("fire"):
		if since_last_fire > 0.2:
			var bullet = Bullet.instance()
			bullet.direction = direction
			bullet.global_position = global_position
			bullet.global_rotation = global_rotation
			get_parent().add_child((bullet))
			since_last_fire = 0
	
	since_last_fire += delta

		
		
