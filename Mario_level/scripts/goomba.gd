extends CharacterBody2D


var SPEED := 10.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $wall_detector as RayCast2D


var direction := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	velocity.x = direction * SPEED

	move_and_slide()



func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		queue_free()


func _on_anim_animation_started(anim_name):
	if anim_name == "hurt":
		SPEED = 0.0
