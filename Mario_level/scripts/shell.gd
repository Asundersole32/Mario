extends CharacterBody2D


var SPEED = 0.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0.0

@onready var left_collision := $left_detector as RayCast2D
@onready var right_collision := $right_detector as RayCast2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if left_collision.is_colliding():
		if left_collision.get_collider().name == "mario":
			SPEED = 200.0
			direction = 1
			set_collision_layer_value(0, false)
			set_collision_layer_value(4, true)
		else:
			direction *= -1
	elif right_collision.is_colliding():
		if right_collision.get_collider().name == "mario":
			SPEED = 200.0
			direction = -1
			set_collision_layer_value(0, false)
			set_collision_layer_value(4, true)
		else:
			direction *= -1
		
	velocity.x = direction * SPEED
	
	move_and_slide()
