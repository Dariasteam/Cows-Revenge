extends Node2D

const HEART_INDICATOR = preload("res://Scenes/Menu/heart_hud.tscn") 

var n_hearts = 0
export var heart_inter_distance = 64
export var initial_heart_pos = Vector2(32, 0)

func reset_values():
	on_set_max_life(global.max_life)	
	
func on_set_max_life(value):
	for element in get_children():
		element.free()
	
	n_hearts = value
	var next_heart_pos = initial_heart_pos
	for i in range(0, n_hearts):
		var next_heart = HEART_INDICATOR.instance()
		next_heart.set_pos(next_heart_pos)
		add_child(next_heart)
		next_heart_pos.x += heart_inter_distance
	
	on_update_life(global.life)

func on_update_life (var n):
	if (n <= 0):
		get_tree().change_scene("res://Scenes/Menu/game_over.tscn")
	else:
		for i in range(0, n):			
			get_children()[i].show()
		for i in range(n, global.max_life):			
			get_children()[i].hide()
	
	
