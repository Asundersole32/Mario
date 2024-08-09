extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()

func change_scene():
	if Global.player_is_on_exit:
		assert(get_tree().change_scene_to_file("res://levels/world_1.tscn") == OK)

func _on_body_entered(body):
	if body.name == "mario":
		Global.player_is_on_the_room = false
		Global.player_is_on_exit = true
