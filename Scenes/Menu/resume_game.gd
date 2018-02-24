extends Button

func _on_Resume_pressed():
	get_tree().set_pause(false)
	get_parent().set_hidden(true)
