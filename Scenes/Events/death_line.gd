extends Area2D

func _on_DeathLine_body_enter( body ):
	if(body.is_in_group("player")):
		body.on_receive_damage(1000)
	elif(body.is_in_group("enemy")):
		body.queue_free()
