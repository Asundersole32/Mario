extends CharacterBody2D

const mushroom_instance := preload("res://actor/mushroom.tscn")
const flower_instance := preload("res://prefabs/fire_flower.tscn")

var hitpoints := 1

@onready var texture := $texture as Sprite2D
@onready var spawn := $spawn as Marker2D

func create_mushroom():
	var mushroom = mushroom_instance.instantiate()
	get_parent().call_deferred("add_child", mushroom)
	mushroom.global_position = spawn.global_position
	texture.texture = load("res://assets/World/empyt_block.png")
	
func create_flower():
	var flower = flower_instance.instantiate()
	get_parent().call_deferred("add_child", flower)
	flower.global_position = spawn.global_position
	texture.texture = load("res://assets/World/empyt_block.png")
