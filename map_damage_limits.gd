extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal damage

func _ready():	
	print ("as")
	connect("damage", get_tree().get_root().get_node("Node2D"), "on_damage")
	

func _on_Area2D_body_enter( body ):
	print ("asdasd")
	if(body.is_in_group("player")):
		emit_signal("damage", 3)
