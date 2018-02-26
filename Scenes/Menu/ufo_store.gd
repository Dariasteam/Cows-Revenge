extends Control
	
func show():
	global.can_show_in_game_menu = false
	get_node("Panel").set_hidden(false)
	get_node("Panel/VButtonArray/Liftoff").update_button()
	get_node("AnimationPlayer").play("slide_down")
	get_node("Panel/VButtonArray/Milk_button").update_price()
	get_node("Panel/VButtonArray/Heart_button").update_price()	
	get_node("Panel/VButtonArray/Return").grab_focus()
	set_process_input(true)

func hide():
	global.can_show_in_game_menu = true
	get_node("AnimationPlayer").play_backwards("slide_down")
	get_node("Panel/VButtonArray/Return").grab_focus()
	get_node("Panel/VButtonArray/Return").release_focus()
	set_process_input(false)

func _on_Button1_pressed():
	get_tree().get_nodes_in_group("player_spawner")[0].deploy()
	hide()

func _input(ev):
	if (ev.is_action_pressed("ui_cancel")):
		_on_Button1_pressed()
