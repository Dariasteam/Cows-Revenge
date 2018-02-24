extends Control
	
func show():
	get_node("Panel").set_hidden(false)
	get_node("Panel/Liftoff").update_button()
	get_node("AnimationPlayer").play("slide_down")
	get_node("Panel/Milk_button").update_price()
	get_node("Panel/Heart_button").update_price()

func hide():	
	get_node("AnimationPlayer").play_backwards("slide_down")
	get_node("Panel/Return").grab_focus()
	get_node("Panel/Return").release_focus()

func _on_Button1_pressed():
	get_tree().get_nodes_in_group("player_spawner")[0].deploy()
	hide()
	
