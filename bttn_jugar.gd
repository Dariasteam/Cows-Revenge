extends Button

func on_Bttn_press():
	global.level = "res://All.tscn"
	get_tree().change_scene("res://All.tscn")

func _ready():
	connect("pressed", self, "on_Bttn_press")

