extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")
var Missile = preload("res://Missile.tscn")

var direction = Vector2(1,0)
var velocity = 600

var since_last_fire = 0

var health = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {
	NORMAL_GUN,
	DOUBLE_BARREL,
	MISSILE
}
var gun_idx = 0
var bullets_available = [-1, 100, 20]
var current_gun = NORMAL_GUN

enum {
	LEFT,
	RIGHT
}

var missile_side = LEFT


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	#print(health)
	look_at(get_global_mouse_position())
	direction = (get_global_mouse_position()-global_position).normalized()
	if Input.is_action_pressed("forward"):
		var delta_position = (get_global_mouse_position()-global_position).normalized()*velocity*delta;
		move_and_collide(delta_position)
	if Input.is_action_pressed("backward"):
		var delta_position = -(get_global_mouse_position()-global_position).normalized()*velocity*delta;
		move_and_collide(delta_position)
	if Input.is_action_pressed("left"):
		var delta_position = (get_global_mouse_position()-global_position).normalized().rotated(-PI/2) * delta * 400
		move_and_collide(delta_position)
	if Input.is_action_pressed("right"):
		var delta_position = (get_global_mouse_position()-global_position).normalized().rotated(PI/2) * delta * 400
		move_and_collide(delta_position)
	if Input.is_action_pressed("fire"):
		if current_gun == NORMAL_GUN:
				if since_last_fire > 0.15:
					var bullet = Bullet.instance()
					bullet.direction = direction
					bullet.global_position = global_position
					bullet.global_rotation = global_rotation
					get_parent().add_child((bullet))
					if not $AudioStreamPlayer2D.playing:
						$AudioStreamPlayer2D.play()
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
					#print(bullets_available)
					since_last_fire = 0
					if not $AudioStreamPlayer2D.playing:
						$AudioStreamPlayer2D.play()
		#if Input.is_action_just_pressed("fire"):
		if current_gun == MISSILE:
			if bullets_available[current_gun] <= 0:
				select_next_gun()
			if since_last_fire > 0.4 and bullets_available[current_gun] > 0:
				var missile = Missile.instance()
				var bullet_position = null
				if missile_side == LEFT:
						bullet_position = $BulletPositionLeft.global_position
						missile_side = RIGHT
				else:
					bullet_position = $BulletPositionRight.global_position
					missile_side = LEFT
				var direction = (get_global_mouse_position() - bullet_position).normalized()
				missile.direction = direction
				missile.global_position = bullet_position
				get_parent().add_child(missile)
				missile.look_at(get_global_mouse_position())
				missile.global_rotation = missile.global_rotation + PI/2

				bullets_available[current_gun] -= 1

				since_last_fire = 0
				if not $AudioStreamPlayer2D.playing:
					$AudioStreamPlayer2D.play()
			
	$HealthBar.value = health
	since_last_fire += delta
		
func _input(_event):
	if Input.is_action_just_pressed("prev_weapon"):
		select_next_gun()
	if Input.is_action_just_pressed("next_weapon"):
		select_prev_gun()
	#print(current_gun)

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
	
		
		


func _on_PowerUpAreaBox_area_entered(area):
	if area.power == area.DOUBLE:
		Global.score += 100
		#bullets_available[DOUBLE_BARREL] = 100
		bullets_available[DOUBLE_BARREL] = max(bullets_available[DOUBLE_BARREL]+100, 500)
		current_gun = DOUBLE_BARREL
	elif area.power== area.HEALTH:
		Global.score += 100
		health = 100
	elif area.power== area.MISSILE:
		Global.score += 100
		bullets_available[MISSILE] = max(bullets_available[MISSILE]+10, 50)
		current_gun = MISSILE
	area.queue_free()




func _on_BulletHitBox_body_entered(body):
	if body.from == "enemy":
		body.queue_free()
		health -= 5
	if health <= 0:
		body.queue_free()
		#queue_free()
		Global.game_over = true
