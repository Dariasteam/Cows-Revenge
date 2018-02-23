extends Control

onready var viewport = get_node("Viewport")
onready var life = get_node("Life")
onready var milk = get_node("Milk_Bar")
onready var cowbells = get_node("Cowbells")

export(Array) var levels
var level_index = 1

func _ready():	
	viewport.add_child(levels[0].instance())
	
func next_level():
	if (level_index < levels.size()):		
		viewport.get_child(0).free()					
		reset_hud()
		viewport.add_child(levels[level_index].instance())
		level_index += 1		
	
func reset_hud():
	life.reset_values()
	milk.reset_values()
	cowbells.reset_values()
