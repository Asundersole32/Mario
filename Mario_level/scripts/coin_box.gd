extends CharacterBody2D

const coin_instance = preload("res://prefabs/coin_rigid.tscn")

@onready var spawn_coin := $spawn_coin as Marker2D
@export var hitpoints := 1

func create():
	print("atingido")
	var coin = coin_instance.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spawn_coin.global_position
	coin.apply_impulse(Vector2(randi_range(-50, 50), -150))
