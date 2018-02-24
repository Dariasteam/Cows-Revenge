extends Button

var ufo

func update_button():
	ufo = get_tree().get_nodes_in_group("player_spawner")[0]	
	if (ufo.can_liftoff()):
		set_disabled(false)
	else:
		set_disabled(true)

func _on_Button_pressed():
	ufo = get_tree().get_nodes_in_group("player_spawner")[0]
	if (ufo.can_liftoff()):
		get_parent().get_parent().hide()
		ufo.liftoff()
		
