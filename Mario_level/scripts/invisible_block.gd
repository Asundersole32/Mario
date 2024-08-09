extends CharacterBody2D

const life_mushroom_instance := preload("res://actor/life_mushroom.tscn")

var hitpoints := 1

@onready var spawn := $spawn as Marker2D
@onready var texture := $texture as Sprite2D

func create_life_mushroom():
	var life_mushroom = life_mushroom_instance.instantiate()
	get_parent().call_deferred("add_child", life_mushroom)
	life_mushroom.global_position = spawn.global_position
	texture.show()
	set_collision_layer_value(8, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(9, true)
	
