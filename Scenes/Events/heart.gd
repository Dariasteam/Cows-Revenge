extends Area2D

export(int) var lifes = 1

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		if (body.can_add_life()):
			body.add_life()
			queue_free()
