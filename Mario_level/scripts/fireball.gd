extends Area2D

class_name Fireball

@onready var detector := $detector as RayCast2D
@onready var right_detector := $right as RayCast2D
@onready var left_detector := $left as RayCast2D

var horizontal_speed = 200
var vertical_speed = 100
var amplitude =20
var is_moving_up = false

var direction
var vertical_moviment_start_position

func _process(delta):
	#print(get_node("../enemies").get_children())
	position.x += delta * horizontal_speed * direction
	if detector.is_colliding():
		is_moving_up = true
		vertical_moviment_start_position = position
	
	if is_moving_up:
		position.y -= vertical_speed * delta
		if vertical_moviment_start_position.y - amplitude >= position.y:
			is_moving_up = false

	if !is_moving_up:
		position.y += delta * vertical_speed

func _on_body_entered(body):
	if get_node("../world_1/enemies").get_children().has(body):
		if body.name == "shell":
			body.queue_free()
		else:
			body.get_node("anim").play("hurt")
			queue_free()
	elif right_detector.is_colliding() or left_detector.is_colliding():
		queue_free()
