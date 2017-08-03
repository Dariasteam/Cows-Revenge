extends Node2D

var max_value
var each_bottle_value
var n_bottles

export(Texture) var sprite1
export(Texture) var sprite2
export(Texture) var sprite3

onready var sprites = [sprite1, sprite2, sprite3]

func on_set_max_milk (maxm):
	max_value = maxm
	each_bottle_value = (float(maxm) / get_children().size())
	n_bottles = get_children().size()

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

