extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_reset_pressed():
	global.release_all()
	get_tree().change_scene(global.level)


func _on_main_menu_pressed():	
	get_tree().change_scene("res://Scenes/Menu/main_menu.tscn")
