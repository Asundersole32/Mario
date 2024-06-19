extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * SPEED

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "mario":
		body.life_points += 1
		queue_free()
