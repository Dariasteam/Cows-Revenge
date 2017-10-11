extends Area2D

export(int) var amount = 100

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		body.add_cowbells(1)
		queue_free()

