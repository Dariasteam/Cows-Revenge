extends Button

func _on_Button_pressed():
	global.level = "res://Scenes/Menu/HUD.tscn"
	get_tree().change_scene("res://Scenes/Menu/HUD.tscn")
