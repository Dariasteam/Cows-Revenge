extends Node2D

func _ready():
	get_node("VButtonArray/reset").grab_focus()
	pass

func _on_reset_pressed():
	global.release_all()
	get_tree().change_scene("res://Scenes/Menu/HUD.tscn")
	queue_free()

func _on_main_menu_pressed():	
	get_tree().change_scene("res://Scenes/Menu/main_menu.tscn")
	queue_free()
