extends CharacterBody2D

const SPEED = 150.0
const JUMP_FORCE = -400.0

const fireball_instance := preload("res://prefabs/fireball.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping := false
var is_shooting := false

var direction

@onready var animation := $anim as AnimatedSprite2D
@onready var right := $right as RayCast2D
@onready var left := $left as RayCast2D
@onready var up := $up as RayCast2D
@onready var down := $down as RayCast2D
@onready var head := $head_collider as Area2D
@onready var hurtbox := $hurtbox as Area2D
@onready var collision := $collision as CollisionShape2D
@onready var timer := $invunerability_timer as Timer
@onready var fireball_position := $shot_position as Marker2D
@onready var pipe_entrance := $"../pipe_entrance" as Area2D
@onready var shooting_timer := $shooting_timer as Timer
@onready var remote_transform := $remote as RemoteTransform2D

signal player_has_died()

func _physics_process(delta):
	if Global.player_is_on_the_pipe and Input.is_action_just_pressed("ui_down"):
		Global.player_is_on_the_room = true
		pipe_entrance.change_scene()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		head.get_child(0).set_disabled(false)
		is_jumping = false
	
	if velocity.y > 0:
		head.get_child(0).set_disabled(true)

	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("shooting") and Global.life_points == 3 and !is_shooting and !is_jumping and !Global.player_is_on_the_room:
		#Esse player_is_on_the_room é uma forma bem safada de corrigir um bug que crasha o jogo, não permitindo que ele atire sem ser no world_1.
		#Em outro momento, depois da entrega, pesquisarei como fazer esse bug nem existir, mas por enquanto essa correção servirá.
		is_shooting = true
		shooting_timer.start()
		shot()
		
		
	if shooting_timer.is_stopped():
		is_shooting = false
		
	if get_collision_mask_value(4) == false and timer.is_stopped():
		set_collision_mask_value(4, true)
		hurtbox.set_collision_mask_value(4, true) 
	
	if down.is_colliding():	
		if down.get_collider().name == "mushroom":
			Global.life_points += 1
			mushroom_power_up()
			down.get_collider().queue_free()
		elif down.get_collider().name == "life_mushroom":
			Global.extra_lifes += 1
			print("Lifes: ", Global.extra_lifes)
			down.get_collider().queue_free()
	
	_set_state()
	_check_positions()
	move_and_slide()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func _check_positions():
	if Global.life_points == 1:
		Global.head_position = Vector2(0, -7)
		Global.up_position = Vector2(0, -7)
		head.get_child(0).position = Global.head_position
		up.position = Global.up_position
	
	if head.get_child(0).position != Global.head_position:
		head.get_child(0).position = Global.head_position
		up.position = Global.up_position

func mushroom_power_up():
	Global.head_position = Vector2(0, -16)
	head.get_child(0).position = Global.head_position
	hurtbox.get_child(0).shape.set_size(Vector2(16, 31))
	collision.shape.set_size(Vector2(14, 30))
	Global.up_position = Vector2(0, -16)
	up.position = Global.up_position

func damage():
	Global.head_position = Vector2(0, -7)
	head.get_child(0).position = Global.head_position
	hurtbox.get_child(0).shape.set_size(Vector2(14, 15))
	collision.shape.set_size(Vector2(12, 14))
	Global.up_position = Vector2(0, -7)
	up.position = Global.up_position
	
func shot():
	set_physics_process(false)
	
	var fireball = fireball_instance.instantiate()
	fireball.direction = sign(animation.scale.x)
	fireball.global_position = fireball_position.global_position
	get_tree().root.add_child(fireball)
	
	set_physics_process(true)
	
func _set_state():
	var state = "idle"

	if !is_on_floor() and Global.life_points == 1:
		state = "jump"
	elif !is_on_floor() and Global.life_points > 2:
		state = "fire_mario_jump"
	elif !is_on_floor() and Global.life_points == 2:
		state = "big_mario_jump"
	elif direction != 0 and Global.life_points == 1:
		state = "run"
	elif direction != 0 and Global.life_points == 2:
		state = "big_mario_run"
	elif direction != 0 and Global.life_points > 2:
		state = "fire_mario_run"
	elif Global.life_points == 2:
		state = "big_mario_idle"
	elif Global.life_points > 2:
		state = "fire_mario_idle"
	
	if is_shooting == true:
		state = "shooting"
	
	if animation.name != state:
		animation.play(state)

func _on_head_collider_body_entered(body):
	if body.has_method("destroy_block") and Global.life_points > 1:
		body.destroy_block()
		
	if body.has_method("create"):
		if body.hitpoints == 1:
			body.hitpoints -= 1
			Global.coins += 1
			print("Coins: ", Global.coins)
			body.create()
		
	if body.has_method("create_mushroom"):
		if body.hitpoints == 1:
			body.hitpoints -= 1
			if Global.life_points == 1:
				body.create_mushroom()
			elif Global.life_points > 1:
				body.create_flower()
	
	if body.has_method("create_life_mushroom"):
		if body.hitpoints == 1:
			body.hitpoints -= 1
			body.create_life_mushroom()
		
func _on_hurtbox_body_entered(body):
	if body.name == "mushroom":
		Global.life_points += 1
		mushroom_power_up()
		body.queue_free()
		
	if body.name == "life_mushroom":
		Global.extra_lifes += 1
		print("Lifes: ", Global.extra_lifes)
		body.queue_free()
	
	if left.is_colliding() and timer.is_stopped():
		if get_node("../enemies").get_children().has(body):
			Global.life_points -= 1
			if Global.life_points == 0 and Global.extra_lifes > 0:
				queue_free()
				emit_signal("player_has_died")
			elif Global.extra_lifes == 0 and Global.life_points == 0:
				queue_free()
			else:
				timer.start()
				set_collision_mask_value(4, false)
				hurtbox.set_collision_mask_value(4, false)
				Global.life_points = 1
				damage()
				
	if right.is_colliding():
		if get_node("../enemies").get_children().has(body):
			Global.life_points -= 1
			if Global.life_points == 0 and Global.extra_lifes > 0:
				queue_free()
				emit_signal("player_has_died")
			elif Global.extra_lifes == 0 and Global.life_points == 0:
				queue_free()
			else:
				timer.start()
				set_collision_mask_value(4, false)
				hurtbox.set_collision_mask_value(4, false)
				Global.life_points = 1
				damage()
