extends CharacterBody2D

const mushroom_instance := preload("res://prefabs/mushroom.tscn")

var hitpoints := 1
@onready var mushroom_spawn := $mushroom_spawn as Marker2D

func create():
	var mushroom = mushroom_instance.instantiate()
	get_parent().call_deferred("add_child", mushroom)
	mushroom.global_position = mushroom_spawn.global_position
