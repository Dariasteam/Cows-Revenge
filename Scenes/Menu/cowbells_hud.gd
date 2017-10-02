extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var label = get_node("Counter")

func set_counter (var quantity):
	label.set_bbcode(" " + String(quantity))