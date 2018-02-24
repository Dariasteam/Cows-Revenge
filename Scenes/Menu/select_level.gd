extends Button

export(int) var id = 0

func _ready():
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	global.level = id
	get_tree().change_scene("res://Scenes/Menu/HUD.tscn")
