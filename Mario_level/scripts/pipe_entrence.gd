extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func change_scene():
	Global.player_is_on_the_pipe = false
	assert(get_tree().change_scene_to_file("res://levels/secret_room.tscn") == OK)

func _on_body_entered(body):
	if body.name == "mario":
		Global.player_is_on_the_pipe = true

func _on_body_exited(body):
	if body.name == "mario":
		Global.player_is_on_the_pipe = false
