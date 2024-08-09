extends CharacterBody2D


var SPEED = 10.0
const JUMP_VELOCITY = -400.0
const shell_instance = preload("res://prefabs/shell.tscn")

@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var spawn := $spanw_shell as Marker2D
@onready var hurtbox := $hurtbox as Area2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false
		
	velocity.x = direction * SPEED

	move_and_slide()
	


func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		var shell = shell_instance.instantiate()
		get_parent().call_deferred("add_child", shell)
		shell.global_position = spawn.global_position
		queue_free()


func _on_anim_animation_started(anim_name):
	if anim_name == "hurt":
		SPEED = 0.0
