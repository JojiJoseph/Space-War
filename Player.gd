extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")

var direction = Vector2(1,0)

var since_last_fire = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {
	NORMAL_GUN,
	DOUBLE_BARREL
}
var gun_idx = 0
var bullets_available = [-1, 100]
var current_gun = NORMAL_GUN


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self


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
		if current_gun == NORMAL_GUN:
				if since_last_fire > 0.2:
					var bullet = Bullet.instance()
					bullet.direction = direction
					bullet.global_position = global_position
					bullet.global_rotation = global_rotation
					get_parent().add_child((bullet))
					since_last_fire = 0
		elif current_gun == DOUBLE_BARREL:
			if bullets_available[current_gun] <= 0:
				select_next_gun()
			if since_last_fire > 0.1 and bullets_available[current_gun] > 0:
					var bullet = Bullet.instance()
					bullet.direction = direction
					bullet.global_position = $BulletPositionLeft.global_position
					bullet.global_rotation = global_rotation
					var bullet2 = Bullet.instance()
					bullet2.direction = direction
					bullet2.global_position = $BulletPositionRight.global_position
					bullet2.global_rotation = global_rotation
					get_parent().add_child((bullet))
					get_parent().add_child((bullet2))
					bullets_available[current_gun] -= 1
					print(bullets_available)
					since_last_fire = 0
			
	
	since_last_fire += delta
	
func _input(event):
	if Input.is_action_just_pressed("prev_weapon"):
		select_next_gun()
	if Input.is_action_just_pressed("next_weapon"):
		select_prev_gun()
	print(current_gun)

func select_next_gun():
	current_gun += 1
	current_gun %= len(bullets_available)
	while current_gun != 0 and bullets_available[current_gun] <= 0:
		current_gun += 1
		current_gun %= len(bullets_available)

func select_prev_gun():
	current_gun -= 1
	if current_gun < 0:
		current_gun = len(bullets_available) - 1
	while current_gun != 0 and bullets_available[current_gun] <= 0:
		current_gun -= 1
		if current_gun < 0:
			current_gun = len(bullets_available) - 1
	
		
		
