extends CharacterBody2D

const coin_instance = preload("res://prefabs/coin_rigid.tscn")

@onready var spawn_coin := $spawn_coin as Marker2D
@onready var texture := $texture as Sprite2D

var hitpoints := 1

func create():
	var coin = coin_instance.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spawn_coin.global_position
	coin.apply_impulse(Vector2(0, -150))
	await get_tree().create_timer(0.2).timeout
	coin.queue_free()
	texture.texture = load("res://assets/World/empyt_block.png")
