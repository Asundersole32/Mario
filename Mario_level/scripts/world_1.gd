extends Node2D

@onready var player := $mario as CharacterBody2D
@onready var pipe_exit := $pipe_exit as Marker2D
@onready var camera := $camera as Camera2D

func _ready():
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
	
func _process(delta):
	if Global.player_is_on_exit:
		on_world_entrance()
		Global.player_is_on_exit = false
		
func reload_game():
	Global.extra_lifes -= 1
	print("Lifes: ", Global.extra_lifes)
	Global.coins = 0
	Global.life_points = 1
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	
func on_world_entrance():
	player.global_position = pipe_exit.global_position
