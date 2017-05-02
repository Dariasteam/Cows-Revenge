extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func on_Bttn_press():
	global.level = "res://All.tscn"
	get_tree().change_scene("res://All.tscn")

func _ready():
	connect("pressed", self, "on_Bttn_press")

