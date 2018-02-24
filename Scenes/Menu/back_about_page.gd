extends Button

export(PackedScene) var scene

func _on_Button_pressed():		
	#get_tree().change_scene_to(scene)
	get_parent().get_node("in_game_menu").set_visible(true)
