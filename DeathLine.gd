extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_DeathLine_body_enter( body ):
	if(body.is_in_group("player")):
		get_tree().get_root().get_node("Node2D").on_damage(3)
		queue_free()
	elif(body.is_in_group("enemy")):
		body.queue_free()
