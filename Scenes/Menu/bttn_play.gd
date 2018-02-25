extends Button

func _ready():
	grab_focus()

func _on_Button_pressed():	
	get_parent().get_parent().queue_free()
	get_tree().change_scene("res://Scenes/Menu/level_selector.tscn")
	
