extends Node2D

const MILK_BOTLE_INDICATOR = preload("res://Scenes/Menu/milk_bottle_hud.tscn") 

var max_value
var n_bottles

export var each_bottle_value = 12.5
export var bottle_inter_distance = 32
export var initial_bottle_pos = Vector2(-10, -20)

export(Texture) var sprite1
export(Texture) var sprite2
export(Texture) var sprite3

onready var sprites = [sprite1, sprite2, sprite3]

func reset_values():
	for element in get_children():
		element.queue_free()
	on_set_max_milk (global.max_milk)

func on_set_max_milk (maxm):
	max_value = maxm
	n_bottles = maxm / each_bottle_value
	var next_bottle_pos = initial_bottle_pos
	for i in range(0, n_bottles):
		var next_bottle = MILK_BOTLE_INDICATOR.instance()
		next_bottle.set_pos(next_bottle_pos)
		add_child(next_bottle)
		next_bottle_pos.x -= bottle_inter_distance

func on_update_milk_bar(value):
	var final = value / each_bottle_value
	var bottle_int = floor (final)
		
	var bottle_float = final - bottle_int
	
	if (bottle_int >= 0):
		for i in range(0, bottle_int):
			get_children()[i].set_value(100)
		
		if (bottle_int < get_children().size()):
			get_children()[bottle_int].set_value(bottle_float * 100)
		
func on_set_bottle_sprite(number):
	for progress_bar in get_children():
		progress_bar.set_over_texture(sprites[number])

