extends Area2D

func _on_body_entered(body):
		if body.name == "mario":
			body.velocity.y = body.JUMP_FORCE
			owner.get_node("anim").play("hurt")
