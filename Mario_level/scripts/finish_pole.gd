extends Area2D

@onready var texture = $texture as Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "mario":
		texture.texture = load("res://assets/World/finish_pole_end.png")
		print("fim do jogo")
