extends Node2D

var max_life

func on_set_max_life(value):
	max_life = value

func on_update_life (var n):
	if (n <= 0):
		get_tree().change_scene("res://game_over.tscn")
	else:
		for i in range(0,n):
			get_children()[i].show()
		for i in range(n,max_life):
			get_children()[i].hide()
	
	
