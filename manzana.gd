extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var amount = 100

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		body.add_milk(amount)
		queue_free()
