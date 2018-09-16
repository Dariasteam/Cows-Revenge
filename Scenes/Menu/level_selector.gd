extends Control

onready var viewport = get_node("Viewport")
onready var life = get_node("Life")
onready var milk = get_node("Milk_Bar")
onready var cowbells = get_node("Cowbells")

export(Array) var levels 

func _ready():
	global.reset_player()
	viewport.add_child(levels[global.level].instance())
	if (global.onscreen_controls == false):
		var nodes = get_tree().get_nodes_in_group("onscreen_controls")
		for element in nodes:
			element.set_hidden(true)
	reset_hud()	
	
func next_level():	
	if (global.level < levels.size()):		
		global.level += 1		
		if (global.level >= global.unlocked_levels):
			global.unlocked_levels += 1
		global.save_game()
		viewport.get_child(0).queue_free()
		#reset_hud()
		viewport.add_child(levels[global.level].instance())

func reset_level():
	viewport.get_child(0).queue_free()
	reset_hud()
	viewport.add_child(levels[global.level].instance())	

func reset_hud():
	life.reset_values()
	milk.reset_values()
	cowbells.reset_values()
	