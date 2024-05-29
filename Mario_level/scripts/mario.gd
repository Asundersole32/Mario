extends CharacterBody2D


const SPEED = 150.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping := false
var direction
@onready var animation := $anim as AnimatedSprite2D
@onready var right := $right_detector as RayCast2D
@onready var left := $left_detector as RayCast2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_set_state()
	move_and_slide()
	
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	if animation.name != state:
		animation.play(state)


func _on_head_collider_body_entered(body):
	if body.has_method("destroy_block"):
		body.destroy_block()
		
	if body.has_method("create"):
		if body.hitpoints == 1:
			body.hitpoints -= 1
			body.create()
		
		


func _on_hurtbox_body_entered(body):
	if left.is_colliding():
		print("left")
		queue_free()
	elif right.is_colliding():
		print("right")
		queue_free()
